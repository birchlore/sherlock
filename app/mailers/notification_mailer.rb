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

  def bulk_scan_notification(shop, total_scanned, total_found, unscanned)
    @total_scanned = total_scanned
    @total_found = total_found
    @scans_remaining = shop.social_scans_remaining
    @unscanned_customers = unscanned

    mail to: shop.email
  end

   def plan_change(shop, old_plan)
    @old_plan = old_plan
    @store = shop.shopify_domain
    @email = shop.email
    @new_plan = shop.plan

    mail to: "jackson@pixelburst.co"
  end

  def scans_depleted(shop)
    mail to: shop.email
  end

  def teaser(customer)
    @celebrity = customer
    mail(to: customer.shop.email, subject: "You sold to a major influencer")
    mail(to: "jackson@pixelburst.co", subject: "#{customer.shop.email} sold to a major influencer")
  end

  def nothing_to_scan(shop)
    mail to: shop.email
  end

end
