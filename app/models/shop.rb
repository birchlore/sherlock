require './lib/modules/plan'

class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include Plan
  include Rails.application.routes.url_helpers
  has_many :celebrities, :inverse_of => :shop, dependent: :destroy
  has_many :customer_records, dependent: :destroy

  def self.store(session)

    shop = Shop.where(:shopify_domain => session.url).first

    if shop.present?
      shop.shopify_token = session.token
      shop.save!
    else
      shop = Shop.create({ shopify_domain: session.url, shopify_token: session.token })
    end

    shop.install unless shop.installed

    shop.id
  end

  def self.retrieve(id)
    
    return unless shop = Shop.where(:id => id).first

    ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token) 
  
  end

  def install
    shopify_session
    set_email
    send_install_notification
    init_webhooks
    self.installed = true
  end

  def shopify_session
    shop_session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(shop_session)
  end

  # def check_webhooks
  #   unless Rails.env.test?
  #     shopify_session

  #   end
  # end

  def scans_allowed
    Plan.scans(self.plan)
  end


  def scans_performed
    scans = customer_records.last
    scans ? scans.count : 0
  end

  def scans_remaining
    sum = scans_allowed - scans_performed
    sum < 0 ? 0 : sum
  end


  def recent_customers(num, include_previously_scanned)
    if include_previously_scanned
      all_customers(num)
    else
      unscanned_customers(num)
    end
  end


  def bulk_scan(num, include_previously_scanned)
    customers = recent_customers(num.to_i, include_previously_scanned)

    scanned_count = customers.count
    @celebrities_count = 0

    emails_on = self.email_notifications

    if emails_on
      self.email_notifications = false
    end

    customers.each do |customer|
      celebrity = celebrities.create(first_name: customer.first_name, last_name: customer.last_name, email: customer.email)
      @celebrities_count += 1 if celebrity.celebrity?
    end

    if emails_on
      self.email_notifications = true
    end


    [scanned_count, @celebrities_count]
    
  end

  def confirm_plan(shopify_plan)

    if shopify_plan != self.plan

      if shopify_plan == "free"

        if charge = self.charge_id
          recurring = ShopifyAPI::RecurringApplicationCharge.find(charge)
          recurring.destroy
          self.charge_id = nil
        end

        self.plan = "free"
        self.save
        celebrities_url(:host => Figaro.env.root_uri)
     
      else
        price = Plan.cost(shopify_plan)
        name = shopify_plan + " Groupie Plan"
        return_url = update_plan_url(:host => Figaro.env.root_uri)
        response = ShopifyAPI::RecurringApplicationCharge.create({
                              :name => name, 
                              :price => price, 
                              :return_url => return_url, 
                              :test=> !Rails.env.production? 
                              })

        response.confirmation_url

      end

    else
         celebrities_url(:host => Figaro.env.root_uri)
    end
  end


  def update_plan(charge)
    if charge.status == "accepted"
      plan = charge.name.split.first
      charge.activate
      self.plan = plan
      self.charge_id = charge.id
      self.save
      "You are now on the #{plan.capitalize} Groupie Plan. Yay!"
    else
      "Charge not processed properly, please try again"
    end
  end



  def all_customers(num)
    pages = 1
    num = scans_remaining if num > scans_remaining

    if num > 250
      num = 250
      total_customers = ShopifyAPI::Customer.count
      pages = (total_customers/250.to_f).ceil
    end

    @count = 1
    @customers = []

    pages.times do
      result = ShopifyAPI::Customer.find(:all, :params => {:limit => num, :page => @count})
      @customers += result.to_a
      @count += 1
    end

     @customers.first(num)
  end


  def unscanned_customers(num)
    num = scans_remaining if num > scans_remaining
  
    total_customers = ShopifyAPI::Customer.count
    pages = (total_customers/250.to_f).ceil


    @page_count = 1
    @filtered_customers = []

    while @filtered_customers.count < num && @page_count < pages do
      @all_customers = ShopifyAPI::Customer.find(:all, :params => {:limit => 250, :page => @page_count})
      
      @counter = 0

      while @filtered_customers.count < num do
        customer = @all_customers[@counter]

        unless celebrities.where(shopify_id: customer.id).first
          @filtered_customers << customer
        end
        @counter += 1
      end

      @page_count += 1

    end

     @filtered_customers
  end

  

  def init_webhooks
    unless Rails.env.test?
      new_customer_callback_url = Figaro.env.root_uri + "/hooks/new_customer_callback"
      uninstall_callback_url = Figaro.env.root_uri + "/hooks/app_uninstalled_callback"

      new_customer_webhook = ShopifyAPI::Webhook.new(:topic => "customers/create", :format => "json", :address => new_customer_callback_url)
      uninstall_webhook = ShopifyAPI::Webhook.new(:topic => "app/uninstalled", :format => "json", :address => uninstall_callback_url)
      
      new_customer_webhook.save
      uninstall_webhook.save
    end
  end


  def active_celebrities
    celebrities.where(status: "active").order(created_at: :desc)
  end

  def set_email
    unless Rails.env.test?
      self.update_attributes({:email => ShopifyAPI::Shop.current.email})
    end
  end

  def twitter_follower_threshold=(followers)
    write_attribute(:twitter_follower_threshold, "#{followers}".gsub(/\D/, ''))
  end

  private

  def send_install_notification
    NotificationMailer.install_notification(self).deliver_now
  end




end
