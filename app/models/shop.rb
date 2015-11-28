require './lib/modules/plan'

class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include Plan
  include Rails.application.routes.url_helpers
  has_many :customers, inverse_of: :shop, dependent: :destroy

  ## Shop model is where we store sessions
  def self.store(session)
    shop = Shop.where(shopify_domain: session.url).first

    if shop.present?
      shop.shopify_token = session.token
      shop.save!
    else
      shop = Shop.create(shopify_domain: session.url, shopify_token: session.token)
    end

    shop.install unless shop.installed
    shop.id
  end

  def self.retrieve(id)
    return unless shop = Shop.where(id: id).first
    ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
  end

  def self.mrr
    @mrr = 0
    Plan.names.each do |plan|
      mrr = Shop.where(installed: true).where(plan: plan).count * Plan.cost(plan)
      @mrr += mrr
    end
    @mrr
  end

  def install
    shopify_session
    set_email
    send_install_notification
    init_webhooks
    self.installed = true
    save
  end


  # we must instantiate a shopify session when we want to make a call to the Shopify API
  def shopify_session
    shop_session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(shop_session)
  end

  def free_influencer_scans_remaining
    teaser_celebrity ? 0 : 1
  end

  def basic_scans_allowed
    Plan.basic_scans(plan)
  end

  def basic_scans_performed(days)
    customers.where('created_at > ?', days.days.ago).where(freebie_scan: false).count
  end

  def basic_scans_remaining
    if plan == 'free'
      sum = basic_scans_allowed - basic_scans_performed(3650)
    else
      sum = basic_scans_allowed - basic_scans_performed(30)
    end

    sum < 0 ? 0 : sum
  end

  def social_scans_allowed
    Plan.social_scans(plan)
  end

  def social_scans_performed(days)
    customers.where('created_at > ?', days.days.ago).where(scanned_on_social: true).where(freebie_scan: false).count
  end

  def social_scans_remaining
    sum = social_scans_allowed - social_scans_performed(30)
    sum = 0 if plan == 'free'
    sum < 0 ? 0 : sum
  end

  def unscanned_customer_count
    num = ShopifyAPI::Customer.count - customers.count
    num = 0 if num < 0
    num
  end

  def teaser_scans_running?
    !Plan.social_scans_enabled?(plan) && !teaser_celebrity
  end


  #onboard scan runs when store owner first installs the app. It scans up to 750 customers to find a customer
  # with at least 1000 followers on a social channel. Average is 120 scans to hit.
  def onboard_scan
    return if onboarded

    customers_to_scan = all_customers(750)

    @celebrity = nil
    @celebrities_count = 0
    @count = 0

    self.email_notifications = false

    while @celebrities_count == 0 && @count < 750 || @count >= customers_to_scan.count
      shopify_customer = customers_to_scan[@count]
      return unless shopify_customer
      customer = customers.new(
        first_name: shopify_customer.first_name,
        last_name: shopify_customer.last_name,
        email: shopify_customer.email,
        shopify_id: shopify_customer.id,
        freebie_scan: true
      )

      customer.teaser_scan
      @count += 1

      next unless customer.teaser_celebrity?
      @celebrity = customer
      @celebrity.status = 'celebrity'
      @celebrity.save
      @celebrities_count += 1

    end

    self.email_notifications = true
    save

    @celebrity
  end

  # store owner has the option to re-scan their previously scanned customers
  def bulk_scan(num, include_previously_scanned)
    customers_to_scan = shopify_customers(num, include_previously_scanned)
    scanned_count = customers_to_scan.count

    if scanned_count > 0

      @celebrities_count = 0

      emails_on = email_notifications

      self.email_notifications = false if emails_on

      customers_to_scan.each do |shopify_customer|
        customer = customers.new(
          first_name: shopify_customer.first_name,
          last_name: shopify_customer.last_name,
          email: shopify_customer.email,
          shopify_id: shopify_customer.id
        )

        customer.scan
        customer.save

        @celebrities_count += 1 if customer.celebrity?
      end

      self.email_notifications = true if emails_on

    end

    [scanned_count, @celebrities_count]
  end


  # step 1 of the shopify recurring charge process. charge must be confirmed by user and then activated by app
  def confirm_charge(shopify_plan)
    if shopify_plan != plan

      if shopify_plan == 'free'

        if charge = charge_id
          recurring = ShopifyAPI::RecurringApplicationCharge.find(charge)
          recurring.destroy
          self.charge_id = nil
        end

        old_plan = plan
        self.plan = 'free'
        save
        NotificationMailer.plan_change(self, old_plan).deliver_now
        customers_url(host: Figaro.env.root_uri)

      else
        price = Plan.cost(shopify_plan)
        name = shopify_plan + ' Groupie Plan'
        return_url = update_plan_step_2_url(host: Figaro.env.root_uri)
        response = ShopifyAPI::RecurringApplicationCharge.create(name: name,
                                                                 price: price,
                                                                 return_url: return_url,
                                                                 test: !Rails.env.production?)
        response.confirmation_url
      end

    else
      customers_url(host: Figaro.env.root_uri)
    end
  end


  # step 2 of shopify recurring charge process
  def activate_charge(charge)
    if charge.status == 'accepted'
      plan = charge.name.split.first
      charge.activate
      self.plan = plan
      self.charge_id = charge.id
      plan
    end
  end


  # returns X customers from the shopify API. 
  # option to only get those customers who have not yet been scanned
  def shopify_customers(num, include_previously_scanned)
    if include_previously_scanned
      all_customers(num)
    else
      unscanned_customers(num)
    end
  end

  # returns X most recent customers back from Shopify API
  # Verbose code is because Shopify only allows you to get a max of 250 customers at a time
  def all_customers(number_of_customers_to_return)
    pages = 1
    num = number_of_customers_to_return

    if number_of_customers_to_return > 250
      num = 250
      total_customers = ShopifyAPI::Customer.count
      pages = (total_customers / 250.to_f).ceil
    end

    @count = 0
    @customers = []

    until @customers.count == number_of_customers_to_return do
      @count += 1
      result = ShopifyAPI::Customer.find(:all, params: { limit: num, page: @count })
      @customers += result.to_a
      break if @count == pages    
    end

    @customers.first(number_of_customers_to_return)
  end

  # returns X most recent customers (who have not been scanned by Groupie) back from Shopify API
  def unscanned_customers(num)
    num = basic_scans_remaining if num > basic_scans_remaining

    @total_customers = ShopifyAPI::Customer.count
    pages = (@total_customers / 250.to_f).ceil

    @page_count = 0
    @filtered_customers = []

    while @filtered_customers.count < num && @page_count < pages

      @page_count += 1
      @customers_on_page = ShopifyAPI::Customer.find(:all, params: { limit: 250, page: @page_count })

      @counter = 0

      while @filtered_customers.count < num && @counter < @customers_on_page.count
        customer = @customers_on_page[@counter]

        if customers.where(shopify_id: customer.id).first.blank?
          @filtered_customers << customer
        end

        @counter += 1
      end

    end

    @filtered_customers
  end

  # runs on first install to setup webhooks
  def init_webhooks
    unless Rails.env.test?
      new_customer_callback_url = Figaro.env.root_uri + '/hooks/new_customer_callback'
      uninstall_callback_url = Figaro.env.root_uri + '/hooks/app_uninstalled_callback'

      new_customer_webhook = ShopifyAPI::Webhook.new(topic: 'customers/create', format: 'json', address: new_customer_callback_url)
      uninstall_webhook = ShopifyAPI::Webhook.new(topic: 'app/uninstalled', format: 'json', address: uninstall_callback_url)

      new_customer_webhook.save
      uninstall_webhook.save
    end
  end
  
  # returns an array of customers who are marked as celebrities
  def celebrities
    customers.where(status: 'celebrity').where(archived: false).order(created_at: :desc)
  end

  # runs when shop is first installed, gets store owners email from the shopify API
  def set_email
    unless Rails.env.test?
      update_attributes(email: ShopifyAPI::Shop.current.email)
    end
  end


  def twitter_follower_threshold=(followers)
    write_attribute(:twitter_follower_threshold, "#{followers}".gsub(/\D/, ''))
  end

  # sent to store owner whenever a new celebrity is found
  def send_celebrity_notification(celebrity)
    if email_notifications
      NotificationMailer.celebrity_notification(celebrity).deliver_now
   end
  end

  private

  # sent to app owner whenever new shop installs
  def send_install_notification
    NotificationMailer.install_notification(self).deliver_now
  end
end
