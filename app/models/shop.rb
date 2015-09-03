class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  has_many :celebrities, :inverse_of => :shop
  after_create :send_email_notification

  def self.store(session)
    shop = Shop.find_or_initialize_by(shopify_domain: session.url)
    shop.shopify_token = session.token
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    return unless id
    shop = Shop.find(id)
    ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # def self.destroy(session)
  #   shop = self.destroy(shopify_domain: session.url, shopify_token: session.token)
  #   shop.id
  # end



  def set_email
    self.email = ShopifyAPI::Shop.current.email
    self.save!
  end

  def init_webhooks
    ShopifyAPI::Webhook.create(:topic => "customers/create", :format => "json", :address => Figaro.env.root_uri + "/hooks/new_customer_callback")
    ShopifyAPI::Webhook.create(:topic => "app/uninstalled", :format => "json", :address => Figaro.env.root_uri + "/hooks/app_uninstalled_callback")
    self.installed = true
    self.save!
  end

  private

  def send_email_notification
    NotificationMailer.install_notification(self).deliver_now
  end



end
