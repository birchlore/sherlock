class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  has_many :celebrities, :inverse_of => :shop
  # after_create :send_email_notification

  after_create :init_webhooks
  after_create :set_email

  def self.store(session)
    shop = Shop.where(:shopify_domain => session.url).first_or_create({ shopify_domain: session.url, 
                                      :shopify_token => session.token,
                                      :installed => true})
    shop.id
  end

  def set_email
    if Rails.env.production?
      self.update_attributes({:email => ShopifyAPI::Shop.current.email})
    end
  end

  def self.retrieve(id)
    shop = Shop.where(:id => id).first
    if shop
      ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
    else
      nil
    end
  end
  
  # def self.destroy(session)
  #   shop = self.destroy(shopify_domain: session.url, shopify_token: session.token)
  #   shop.id
  # end

  def init_webhooks

    # webhooks weren't working on shopify when I used Figaro.env.root_uri + "/hooks/new_customer_callback". Afraid to change this now without messing it up..
    if Rails.env.production?
      new_customer = ShopifyAPI::Webhook.new(:topic => "customers/create", :format => "json", :address => "https://groupie.pixelburst.co/hooks/new_customer_callback")
      uninstall = ShopifyAPI::Webhook.new(:topic => "app/uninstalled", :format => "json", :address => "https://groupie.pixelburst.co/hooks/app_uninstalled_callback")
      
      new_customer.save
      uninstall.save
    end

    puts "saved"
    self.save!
  
  end

  def twitter_follower_threshold=(followers)
    write_attribute(:twitter_follower_threshold, "#{followers}".gsub(/\D/, ''))
  end

  private

  def send_email_notification
    NotificationMailer.install_notification(self).deliver_now
  end




end
