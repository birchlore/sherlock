require 'resque-retry'

class Onboard
	extend Resque::Plugins::Retry

	@queue = :onboard_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id)
	  shop = Shop.find(shop_id)

	  begin
		  shop.update_attributes :onboard_status => "started"
		  @celebrity = shop.onboard_scan
		  shop.onboarded = true
		  shop.onboard_status = "success"
	  	  shop.save
	   rescue Exception => e
	   	   Rollbar.error(e)
	   	  shop.update_attributes :onboard_status => "error"
	   end
	end

end

#commit