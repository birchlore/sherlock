require 'resque-retry'

class HookScanner
	extend Resque::Plugins::Retry

	@queue = :hook_scanner_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id, customer_id)
	  shop = Shop.find(shop_id)
	  shop_session = Shop.retrieve(shop_id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  customer = Customer.find(customer_id)
	  customer.scan 
	  customer.save
	end

end

#commit