class DelayedMailer < ApplicationMailer
  helper CustomersHelper
  include Resque::Mailer

  def uninstall_feedback(shop)
    mail(to: shop.email, subject: "celebrity app")
  end


end
