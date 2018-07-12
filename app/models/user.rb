class User < ApplicationRecord
  has_many :notifications
  has_many :checkouts

  has_many :checkouts_reviewed,     class_name: "Checkout", foreign_key: "reviewed_by_id"
  has_many :checkouts_checked_in,   class_name: "Checkout", foreign_key: "checked_in_by_id"
  has_many :checkouts_checked_out,  class_name: "Checkout", foreign_key: "checked_out_by_id"

  has_secure_password

  validates_uniqueness_of :email
  validates_email_format_of :email, message: "is invalid"
  validates :password, length: {within: 8..32}, on: :create

  before_create :generate_confirmation_token

  def admin?
    self.permission_level == 1
  end

  def create_dummy_notification
    self.notifications.create(user: self, importance: 4, notif_type: "dummy", head: "Dummy Notification", body: "Dummy notification body")
  end
  
  def generate_confirmation_token
    if self.confirm_token.nil?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
