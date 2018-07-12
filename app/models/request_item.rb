class RequestItem < ApplicationRecord
  belongs_to :item
  belongs_to :request

  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validate :item_present
  validate :request_present
  # validate :enough_available

  validates_uniqueness_of :item_id, scope: :request_id

  private
  def item_present
    if item.nil?
      errors.add(:item, " is not present")
    end
  end

  def request_present
    if request.nil?
      errors.add(:request, " is not present")
    end
  end

  # def enough_available
  #  if item.available < quantity
  #    errors.add(:item, "does not have enough available")
  #  end
  # end
end
