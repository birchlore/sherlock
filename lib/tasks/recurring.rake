task :send_upgrade_reminder_email => :environment do
  shops = Shop.where(plan: "free").where(installed:"true")

  shops.each do |shop|
  	NotificationMailer.upgrade_reminder(shop.id).deliver_now
  end

end
