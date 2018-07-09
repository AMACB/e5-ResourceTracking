class Notification < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :importance, :notif_type, :head, :body
  validates :importance, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read
    self.update_attribute :read_at, Time.zone.now
  end
end
