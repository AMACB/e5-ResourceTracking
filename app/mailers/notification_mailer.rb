class NotificationMailer < ApplicationMailer
  def notify(notif)
    @notif = notif
    mail(to: notif.user.email, subject: "#{notif.head}: APRD Resource Management")
  end
end
