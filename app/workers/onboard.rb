require 'resque-retry'

class Onboard
	extend Resque::Plugins::Retry

	@queue = :onboard_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id)
	  shop = Shop.find(shop_id)
	  shop_session = Shop.retrieve(shop_id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  begin
		  @celebrity = shop.onboard_scan
		  @celebrity.save
		  shop.update_attributes :onboard_status => "success"
	   rescue Exception => e
	   	   Rollbar.error(e)
	   	  shop.update_attributes :onboard_status => "error"
	   end
	end

end

#commit