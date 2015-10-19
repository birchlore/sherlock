class BulkScanner
	@queue = :bulk_scanner_queue

	def self.perform(shop_id, num, scan_existing)
	  shop = Shop.find(shop_id)
	  shop_session = Shop.retrieve(shop_id)
	  ShopifyAPI::Base.activate_session(shop_session)

	  result = shop.bulk_scan(num, scan_existing)
	  total_scanned = result[0]
      total_found = result[1]

	  if total_scanned > 0
		  NotificationMailer.bulk_scan_notification(shop, total_scanned, total_found, shop.unscanned_customer_count).deliver_now
	  else
	  	  NotificationMailer.nothing_to_scan(shop).deliver_now
	  end

	end

end