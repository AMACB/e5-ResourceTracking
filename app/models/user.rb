class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  validates_email_format_of :email
  validates :password, length: {within: 8..32}, on: :create

  def admin?
    self.permission_level == 1
  end
end
