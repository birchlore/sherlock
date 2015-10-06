class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  has_many :celebrities, :inverse_of => :shop, dependent: :destroy

  def self.store(session)
    shop = Shop.where(:shopify_domain => session.url).first_or_create({ shopify_domain: session.url, 
                                      :shopify_token => session.token})
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

  def install

    set_email
print "!!!!!!!!!!!!! email set !!!!!!!!!!!!!!!!!!"

    send_install_notification
    print "!!!!!!!!!!!!! sent install notification !!!!!!!!!!!!!!!!!!"


    init_webhooks
     print "!!!!!!!!!!!!! ran init webhooks !!!!!!!!!!!!!!!!!!"


    self.installed = true

    print "!!!!!!!!!!!!! self installed true !!!!!!!!!!!!!!!!!!"
    self.save!

    print "!!!!!!!!!!!!! saved !!!!!!!!!!!!!!!!!!"
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
  

  def init_webhooks
    unless Rails.env.test?
      new_customer_callback_url = Figaro.env.root_uri + "/hooks/new_customer_callback"
      uninstall_callback_url = Figaro.env.root_uri + "/hooks/app_uninstalled_callback"

      new_customer = ShopifyAPI::Webhook.new(:topic => "customers/create", :format => "json", :address => new_customer_callback_url)
      uninstall = ShopifyAPI::Webhook.new(:topic => "app/uninstalled", :format => "json", :address => uninstall_callback_url)
      
      new_customer.save
      uninstall.save
    end
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

  def send_install_notification
    NotificationMailer.install_notification(self).deliver_now
  end




end
