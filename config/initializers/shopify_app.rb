ShopifyApp.configure do |config|
  config.api_key = Figaro.env.shopify_api_key
  config.secret = Figaro.env.shopify_secret
  config.redirect_uri = Figaro.env.shopify_redirect_uri
  config.scope = "read_orders, read_customers, write_customers"
  config.embedded_app = ("true" == Figaro.env.shopify_embedded_app)
end


