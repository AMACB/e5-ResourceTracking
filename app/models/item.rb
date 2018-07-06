class Item < ApplicationRecord
  belongs_to :category
  has_many :checkout_items

  validates_presence_of :name, :description, :category

  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :enough_total

  # validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  def is_available_from?(date_begin, date_end)
    cis = self.checkout_items
    cis.each do |ci|
      c = ci.checkout
      if [c.need_by, date_begin].max <= [c.return_by, date_end].min
        return false
      end 
    end
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
