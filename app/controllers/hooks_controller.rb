require 'pry'

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :only=> [:new_customer_callback, :app_uninstalled_callback]
  before_filter :verify_webhook, :except => 'verify_webhook'

  def new_customer_callback
    data = ActiveSupport::JSON.decode(request.body.read)

    # confirms customer has made at least one order, to avoid abandoned cart customers being created
    # if data["last_order_id"]

      shopify_domain = request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"]
      shop = Shop.where(shopify_domain: shopify_domain).first
      first_name = data["first_name"]
      last_name = data["last_name"]
      email = data["email"]
      id = data["id"]
      shopify_url = shopify_domain + "/admin/customers/" + id.to_s

       if shop
        celebrity = shop.celebrities.new(:first_name => first_name, :last_name => last_name, :email => email, :shopify_url => shopify_url)
        celebrity.save
       end

     # end

      head :ok

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
