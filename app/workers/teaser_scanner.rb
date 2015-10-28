require 'resque-retry'

class TeaserScanner
	extend Resque::Plugins::Retry

	@queue = :teaser_scanner_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id, customer)
	  shop = Shop.find(shop_id)
	  shop_session = Shop.retrieve(shop_id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  customer = customer
	  customer.teaser_scan
	end

end

#commit