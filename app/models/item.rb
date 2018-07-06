class Item < ApplicationRecord
  belongs_to :category
  has_many :checkout_items

  validates_presence_of :name, :description, :category

  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :enough_total

  # validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  def conflicting_ranges(date_begin, date_end)
    CheckoutItem.select(
      'checkout_items.quantity, checkouts.need_by AS need_by, checkouts.return_by AS return_by, checkouts.id AS checkout_id'
    ).where(
      Checkout.arel_table[:need_by].lteq(date_end).and(
        Checkout.arel_table[:return_by].gt(date_begin)
      )
    ).joins(
      CheckoutItem.arel_table.join(Checkout.arel_table).on(
        Checkout.arel_table[:id].eq(CheckoutItem.arel_table[:checkout_id]).and(
          CheckoutItem.arel_table[:item_id].eq(self[:id]).and(Checkout.arel_table[:status].in([2, 3]))
        )
      ).join_sources
    ).order(Checkout.arel_table[:return_by], Checkout.arel_table[:need_by]).collect {|x| [Date.parse(x.need_by), Date.parse(x.return_by), x.quantity, x.checkout_id] }
  end

  def max_used_between(date_begin, date_end)
    ranges = conflicting_ranges(date_begin, date_end)

    endpoints = (ranges.flat_map { |x| [x[0], x[1]] }).uniq.sort

    sums = Array.new(endpoints.length - 1, 0)

    ranges.each do |r|
      (endpoints.index(r[0])...endpoints.index(r[1])).each do |i|
        sums[i] += r[2]
      end
    end

    return sums.max
  end

  def is_available_from?(date_begin, date_end, qty)
    return available - max_used_between(date_begin, date_end) >= qty
  end

  def available
    self[:total] - self[:unavailable]
  end

  # private
  def enough_total
    if self[:total] < self[:unavailable]
      errors.add(:total, "is too small for unavailable")
    end
  end
end
