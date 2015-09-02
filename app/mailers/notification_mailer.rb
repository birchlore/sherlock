class NotificationMailer < ApplicationMailer

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
end
