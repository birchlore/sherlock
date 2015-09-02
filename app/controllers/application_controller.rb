class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_shop
  helper_method :trigger_login


  def current_shop
    @_current_shop ||= Shop.where(:shopify_token => @shop_session.token, :shopify_domain => @shop_session.url).first
  end

  def trigger_login
    ShopifyAPI::Customer.last
  end

end
