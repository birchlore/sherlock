class NotificationMailer < ApplicationMailer
  helper CelebritiesHelper

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

    mail to: "jackson@pixelburst.co"
  end

   def uninstall_notification(shop)
    @greeting = "Hi"
    
    @email = shop.email

    mail to: "jackson@pixelburst.co"
  end

end
