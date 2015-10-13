class NotificationMailer < ApplicationMailer
  helper CustomersHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.celebrity_notification.subject
  #
  def celebrity_notification(celebrity)
    @greeting = "Hi"
    
    @celebrity = celebrity

    mail to: celebrity.shop.email
  end

   def install_notification(shop)
    @greeting = "Hi"
    
    @domain = shop.shopify_domain
    @email = shop.email

    mail to: "jackson@pixelburst.co"
  end

  def uninstall_notification(shop)
    @greeting = "Hi"
    
    @email = shop.email

    mail to: "jackson@pixelburst.co"
  end

  def bulk_scan_notification(shop, total_scanned, total_found)
    @greeting = "Hi"
    @total_scanned = total_scanned
    @total_found = total_found
    @scans_remaining = shop.scans_remaining

    mail to: shop.email
  end

end
