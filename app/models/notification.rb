class Notification < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :importance, :notif_type, :head, :body
  validates :importance, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  scope :unread, -> { where(read_at: nil) }

  after_create :try_send_email_notif

  def mark_as_read
    self.read_at = Time.zone.now
    self.save
  end

  def try_send_email_notif
    if user.receive_email_notifications
      NotificationMailer.notify(self).deliver
    end
  end
end
