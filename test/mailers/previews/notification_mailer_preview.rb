# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def notify_preview
    NotificationMailer.notify(Notification.first)
  end
end
