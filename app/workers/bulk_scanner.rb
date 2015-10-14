class BulkScanner
	@queue = :bulk_scanner_queue

	def self.perform(shop_id, num, scan_existing)
	  shop = Shop.find(shop_id)
	  shop.shopify_session

	  result = shop.bulk_scan(num, scan_existing)
	  total_scanned = result[0]
      total_found = result[1]

	  NotificationMailer.bulk_scan_notification(shop, total_scanned, total_found).deliver_now
	end

end