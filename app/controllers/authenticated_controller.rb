class AuthenticatedController < ApplicationController
  before_action :login_again_if_different_shop
  around_filter :shopify_session
  layout ShopifyApp.configuration.embedded_app? ? 'embedded_app' : 'application'
  helper_method :current_shop

  def current_shop
    @_current_shop ||= Shop.where(:shopify_token => @shop_session.token, :shopify_domain => @shop_session.url).first
  end
end
