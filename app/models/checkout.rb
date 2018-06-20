class Checkout < ApplicationRecord
  has_many :checkout_items
  belongs_to :user
  before_create :set_status

  private
  def set_status
    self.status = 0
  end
end
