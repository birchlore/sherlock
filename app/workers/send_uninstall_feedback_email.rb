require 'resque-retry'

class SendUninstallFeedbackEmail
	extend Resque::Plugins::Retry

	@queue = :uninstall_feedback_queue

	@retry_limit = 3
    @retry_delay = 60

	def self.perform(shop_id)
	  shop = Shop.find(shop_id)
	  NotificationMailer.uninstall_feedback(shop).deliver_now
	end

end




 

    