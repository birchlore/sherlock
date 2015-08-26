ShopifyApp.configure do |config|
  config.api_key = "6254538a1725c3e9964960d392e18254"
  config.secret = "71bc8737581229f75d454c578fdbf317"
  config.redirect_uri = "http://3dcdd228.ngrok.io/auth/shopify/callback"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end


