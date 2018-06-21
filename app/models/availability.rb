class Availability < ApplicationRecord
  belongs_to :item

  validates_uniqueness_of :item_id
  validates :available, numericality: { only_integer: true, greater_than: 0 }
  validates :checked_out, numericality: { only_integer: true, greater_than: 0 }
  validates :unavailable, numericality: { only_integer: true, greater_than: 0 }
  validates :total, numericality: { only_integer: true, greater_than: 0 }
  
  before_save :update_total

  def update_total
    self[:total] = self[:available] - self[:checked_out] - self[:unavailable]
  end
end
