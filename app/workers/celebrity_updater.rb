require 'resque-retry'

class CelebrityUpdater
	extend Resque::Plugins::Retry

	@queue = :celebrity_updater_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id)
	  shop = Shop.find(shop_id)

	  shop.customers.each do |customer|
	  	original_status = customer.status
	  	if customer.celebrity?
      		customer.status = "celebrity"
      	else
      		customer.status = "regular"
      	end

      	customer.save if customer.status != original_status
      end  
	end
	
end




 
