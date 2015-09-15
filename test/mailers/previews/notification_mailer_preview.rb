# Preview all emails at http://localhost:3000/rails/mailers/model_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/Notification_mailer/celebrity_notification
  def celebrity_notification
    NotificationMailer.celebrity_notification
  end

end
