class NotificationMailer < ApplicationMailer
  helper CustomersHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.celebrity_notification.subject
  #
  def celebrity_notification(celebrity)
    
    @celebrity = celebrity

    mail to: celebrity.shop.email
  end

   def install_notification(shop)
    
    @domain = shop.shopify_domain
    @email = shop.email

    mail to: "jackson@pixelburst.co"
  end

  def uninstall_notification(shop)
    
    @email = shop.email

    mail to: "jackson@pixelburst.co"
  end

  def bulk_scan_notification(shop, total_scanned, total_found)
    @total_scanned = total_scanned
    @total_found = total_found
    @scans_remaining = shop.scans_remaining
    @unscanned_customers = shop.unscanned_customer_count

    mail to: shop.email
  end

   def plan_change(shop, old_plan)
    @old_plan = old_plan
    @store = shop.shopify_domain
    @email = shop.email
    @new_plan = shop.plan

    mail to: "jackson@pixelburst.co"
  end


  def nothing_to_scan(shop)
    mail to: shop.email
  end

end
