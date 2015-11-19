class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  protect_from_forgery with: :exception
  helper_method :current_shop

  def current_shop
    @_current_shop ||= Shop.where(shopify_token: @shop_session.token, shopify_domain: @shop_session.url).first
  end
end
