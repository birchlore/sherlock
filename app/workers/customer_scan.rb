class CustomerScan
	@queue = :customer_scan_queue

	def self.perform(customer_id)
	  customer = Customer.find(customer_id)

	  shop_session = Shop.retrieve(customer.shop.id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  data = customer.get_external_data
	  return unless data
	  customer.get_celebrity_status

	  if customer.celebrity?
	    customer.shop.send_celebrity_notification(self) 
	    customer.status = "celebrity"
	    customer.save
	  end

	end

end