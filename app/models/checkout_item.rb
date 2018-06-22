class CheckoutItem < ApplicationRecord
  belongs_to :item
  belongs_to :checkout

  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validate :item_present
  validate :checkout_present
  validate :enough_available

  validates_uniqueness_of :item_id, scope: :checkout_id

  private
  def item_present
    if item.nil?
      errors.add(:item, " is not valid")
    end
  end

  def checkout_present
    if checkout.nil?
      errors.add(:checkout, " is not valid")
    end
  end

  def enough_available
    if item.available < quantity
      errors.add(:item, "does not have enough available")
    end
  end
end
