require 'pry'

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new_customer_callback, :app_uninstalled_callback]
  before_filter :verify_webhook, except: 'verify_webhook'

  def new_customer_callback
    data = ActiveSupport::JSON.decode(request.body.read)

    shopify_domain = request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
    shop = Shop.where(shopify_domain: shopify_domain).first
    return unless shop
    basic_scans_remaining = shop.basic_scans_remaining

    head :ok

    return if basic_scans_remaining < 1

    first_name = data['first_name']
    last_name = data['last_name']
    email = data['email']
    shopify_id = data['id']

    Resque.enqueue(HookScanner, shop.id, shopify_id, first_name, last_name, email)
  end

  def app_uninstalled_callback
    shopify_domain = request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
    shop = Shop.where(shopify_domain: shopify_domain).first

    head :ok

    return unless shop

    shop.plan = "free"
    shop.installed = false
    shop.save!
    Resque.enqueue_in(1.hour, SendUninstallFeedbackEmail, shop.id)
    NotificationMailer.uninstall_notification(shop).deliver_now
  end

  private

  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, Figaro.env.shopify_secret, data)).strip
    head :unauthorized unless calculated_hmac == hmac_header
    request.body.rewind
  end
end
