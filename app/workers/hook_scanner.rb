require 'resque-retry'

class HookScanner
	extend Resque::Plugins::Retry

	@queue = :hook_scanner_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id, shopify_id, first_name, last_name, email)
	  shop = Shop.find(shop_id)
	  shop_session = Shop.retrieve(shop_id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  customer = shop.customers.new(:shopify_id => shopify_id, :first_name => first_name, :last_name => last_name, :email => email)
	  customer.scan 
	  customer.save
	end

end

#commit