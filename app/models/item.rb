class Item < ApplicationRecord
  belongs_to :category
  has_many :checkout_items

  validates_presence_of :name, :description, :category

  validates :available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :checked_out, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  before_validation :update_available

  def update_available
    self[:available] = self[:total] - self[:checked_out] - self[:unavailable]
  end

  def is_available_from?(date_begin, date_end)
    c = CheckoutItems.joins(:checkout_items).where('checkout_items.checkout.status = 2 OR 3')
    return true # TODO
  end
end
