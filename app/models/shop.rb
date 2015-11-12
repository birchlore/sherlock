require './lib/modules/plan'

class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include Plan
  include Rails.application.routes.url_helpers
  has_many :customers, :inverse_of => :shop, dependent: :destroy
  has_many :celebrities, :inverse_of => :shop, dependent: :destroy
  # has_many :customers, :inverse_of => :shop, dependent: :destroy 
  # has_many :customer_records, dependent: :destroy

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


  def self.mrr
    @mrr = 0
    Plan.names.each do |plan|
      mrr = Shop.where(plan: plan).count * Plan.cost(plan)
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
    self.save
  end

  def shopify_session
    shop_session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(shop_session)
  end

  def free_influencer_scans_remaining
    self.teaser_celebrity ? 0 : 1  
  end


  def basic_scans_allowed
    Plan.basic_scans(self.plan)
  end


  def basic_scans_performed(days)
    customers.where('created_at > ?', days.days.ago).where(freebie_scan: false).count
  end

  def basic_scans_remaining
    if self.plan == "free"
      sum = basic_scans_allowed - basic_scans_performed(3650)
    else
      sum = basic_scans_allowed - basic_scans_performed(30)
    end

    sum < 0 ? 0 : sum
  end


  def social_scans_allowed
    Plan.social_scans(self.plan)
  end

  def social_scans_performed(days)
    customers.where('created_at > ?', days.days.ago).where(scanned_on_social: true).where(freebie_scan: false).count
  end

  def social_scans_remaining
    sum = social_scans_allowed - social_scans_performed(30)
    sum = 0 if self.plan == "free"
    sum < 0 ? 0 : sum
  end



  def unscanned_customer_count
    num = ShopifyAPI::Customer.count - self.customers.count
    num = 0 if num < 0
    num
  end


  def teaser_scans_running?
    !Plan.social_scans_enabled?(self.plan) && !teaser_celebrity
  end


  def onboard_scan

    return if self.onboarded

    customers_to_scan = all_customers(750)

    @celebrity = nil
    @celebrities_count = 0
    @count = 0

    self.email_notifications = false

    while @celebrities_count == 0 && @count < 750 || @count >= customers_to_scan.count
        shopify_customer = customers_to_scan[@count]
        return unless shopify_customer
        customer = self.customers.new(
                                first_name: shopify_customer.first_name,
                                last_name: shopify_customer.last_name,
                                email: shopify_customer.email,
                                shopify_id: shopify_customer.id,
                                freebie_scan: true
          )


        customer.teaser_scan
        @count += 1
        
        if customer.teaser_celebrity?
          @celebrity = customer
          @celebrity.status = "celebrity"
          @celebrity.save
          @celebrities_count += 1 
        end

    end

    self.onboarded => true
    self.email_notifications = true
    self.save

    @celebrity

  end



  def bulk_scan(num, include_previously_scanned)

    customers_to_scan = shopify_customers(num, include_previously_scanned)
    scanned_count = customers_to_scan.count

    if scanned_count > 0

      @celebrities_count = 0

      emails_on = self.email_notifications

      if emails_on
        self.email_notifications = false
      end

      customers_to_scan.each do |shopify_customer|
        customer = self.customers.new(
                                first_name: shopify_customer.first_name,
                                last_name: shopify_customer.last_name,
                                email: shopify_customer.email,
                                shopify_id: shopify_customer.id
          )


        customer.scan
        customer.save
        
        if customer.celebrity?
          @celebrities_count += 1 
        end

      end

      if emails_on
        self.email_notifications = true
      end

    end


    [scanned_count, @celebrities_count]
    
  end

  def confirm_charge(shopify_plan)

    if shopify_plan != self.plan

      if shopify_plan == "free"

        if charge = self.charge_id
          recurring = ShopifyAPI::RecurringApplicationCharge.find(charge)
          recurring.destroy
          self.charge_id = nil
        end

        old_plan = self.plan
        self.plan = "free"
        self.save
        NotificationMailer.plan_change(self, old_plan).deliver_now
        customers_url(:host => Figaro.env.root_uri)
     
      else
        price = Plan.cost(shopify_plan)
        name = shopify_plan + " Groupie Plan"
        return_url = update_plan_step_2_url(:host => Figaro.env.root_uri)
        response = ShopifyAPI::RecurringApplicationCharge.create({
                              :name => name, 
                              :price => price, 
                              :return_url => return_url, 
                              :test=> !Rails.env.production? 
                              })
        response.confirmation_url
      end

    else
         customers_url(:host => Figaro.env.root_uri)
    end
  end


  def activate_charge(charge)
    if charge.status == "accepted"
      plan = charge.name.split.first
      charge.activate
      self.plan = plan
      self.charge_id = charge.id
      plan
    end
  end



  def shopify_customers(num, include_previously_scanned)
    if include_previously_scanned
      all_customers(num)
    else
      unscanned_customers(num)
    end
  end


# # returns the number of customers a store has had in last X days from Shopify API
#   def customers_since(date)
    
#   end




  def all_customers(num)
    pages = 1

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
    num = basic_scans_remaining if num > basic_scans_remaining
  
    @total_customers = ShopifyAPI::Customer.count
    pages = (@total_customers/250.to_f).ceil


    @page_count = 0
    @filtered_customers = []


    while @filtered_customers.count < num && @page_count < pages do
     
      @page_count += 1
      @customers_on_page = ShopifyAPI::Customer.find(:all, :params => {:limit => 250, :page => @page_count})

      @counter = 0

      while @filtered_customers.count < num && @counter < @customers_on_page.count do
        customer = @customers_on_page[@counter]

        if customers.where(shopify_id: customer.id).first.blank?
          @filtered_customers << customer
        end

        @counter += 1
      end

      

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


  def celebrities
    customers.where(status: "celebrity").where(archived: false).order(created_at: :desc)
  end

  def set_email
    unless Rails.env.test?
      self.update_attributes({:email => ShopifyAPI::Shop.current.email})
    end
  end

  def twitter_follower_threshold=(followers)
    write_attribute(:twitter_follower_threshold, "#{followers}".gsub(/\D/, ''))
  end

  def send_celebrity_notification(celebrity)
     if self.email_notifications
        NotificationMailer.celebrity_notification(celebrity).deliver_now
    end
  end


  private

  def send_install_notification
    NotificationMailer.install_notification(self).deliver_now
  end




end
