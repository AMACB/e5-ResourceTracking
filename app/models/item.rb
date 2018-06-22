class Item < ApplicationRecord
  belongs_to :category
  has_many :checkout_items

  validates :available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :checked_out, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  before_save :update_available

  def update_available
    self[:available] = self[:total] - self[:checked_out] - self[:unavailable]
  end
end
