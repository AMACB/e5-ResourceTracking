class Item < ApplicationRecord
  belongs_to :category
  has_many :checkout_items

  validates_presence_of :name, :description, :category

  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :enough_total

  # validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  def is_available_from?(date_begin, date_end)
    c = CheckoutItems.joins(:checkout_items).where('checkout_items.checkout.status = 2 OR 3')
    return true # TODO
  end

  def available
    self[:total] - self[:unavailable]
  end

  private
  def enough_total
    if self[:total] < self[:unavailable]
      errors.add(:total, "is too small for unavailable")
    end
  end
end
