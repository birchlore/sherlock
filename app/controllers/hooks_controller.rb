require 'pry'

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :only=> [:new_customer_callback, :app_uninstalled_callback]
  before_filter :verify_webhook, :except => 'verify_webhook'

  def new_customer_callback
    data = ActiveSupport::JSON.decode(request.body.read)
    
    shopify_domain = request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"]
    shop = Shop.where(shopify_domain: shopify_domain).first
    basic_scans_remaining = shop.basic_scans_remaining

    head :ok

    return if basic_scans_remaining < 1 && shop.teaser_celebrity

    
    
    first_name = data["first_name"]
    last_name = data["last_name"]
    email = data["email"]
    id = data["id"]
    customer = shop.customers.new(:shopify_id => id)

     if shop && !customer.duplicate?
        customer.update_attributes(:first_name => first_name, :last_name => last_name, :email => email)

        if basic_scans_remaining > 0
          Resque.enqueue(HookScanner, shop.id, id, first_name, last_name, email)
        end

        Resque.enqueue(HookScanner, shop.id, id, first_name, last_name, email) if shop.teaser_scans_running?

     end

  end

  def app_uninstalled_callback
    data = ActiveSupport::JSON.decode(request.body.read)
    shopify_domain = request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"]
    shop = Shop.where(shopify_domain: shopify_domain).first
    shop.installed = false
    shop.save!
    NotificationMailer.uninstall_notification(shop).deliver_now
    head :ok
  end

  private
  
  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, Figaro.env.shopify_secret, data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end

end
