class CheckoutItem < ApplicationRecord
  belongs_to :item
  belongs_to :checkout

  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validate :item_present
  validate :checkout_present

  private
  def item_present
    if item.nil?
      errors.add(:item, " is not valid")
    end
  end

  def checkout_present
    if checkout.nil?
      errors.add(:checkout, " is not a valid checkout")
    end
  end
end
