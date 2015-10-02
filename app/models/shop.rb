class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  has_many :celebrities, :inverse_of => :shop, dependent: :destroy
  # after_create :send_email_notification

  after_create :init_webhooks
  after_create :set_email

  def self.store(session)
    shop = Shop.where(:shopify_domain => session.url).first_or_create({ shopify_domain: session.url, 
                                      :shopify_token => session.token,
                                      :installed => true})
    shop.id
  end

  def self.retrieve(id)
    shop = Shop.where(:id => id).first
    if shop
      ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
    else
      nil
    end
  end

  def shopify_session
    shop_session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(shop_session)
  end
  

  def init_webhooks
    unless Rails.env.test?
      shopify_session

      new_customer_callback_url = Figaro.env.root_uri + "/hooks/new_customer_callback"
      uninstall_callback_url = Figaro.env.root_uri + "/hooks/app_uninstalled_callback"

      new_customer = ShopifyAPI::Webhook.new(:topic => "customers/create", :format => "json", :address => new_customer_callback_url)
      uninstall = ShopifyAPI::Webhook.new(:topic => "app/uninstalled", :format => "json", :address => uninstall_callback_url)
      
      new_customer.save
      uninstall.save
    end

    puts "saved"
    self.save!
  end

  def active_celebrities
    celebrities.where(status: "active").reverse
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

  def send_email_notification
    NotificationMailer.install_notification(self).deliver_now
  end




end
