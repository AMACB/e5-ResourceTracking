class Item < ApplicationRecord
  belongs_to :category
  has_many :request_items

  # scope :available_between, (date_begin, date_end) -> { is_available_from(date_begin, date_end, 1) }

  validates_presence_of :name, :description, :category

  validates :unavailable, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :enough_total

  # validates :condition, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }

  def conflicting_ranges(date_begin, date_end)
    RequestItem.select(
      'request_items.quantity, requests.requested_pick_up_date AS requested_pick_up_date, requests.requested_return_date AS requested_return_date, requests.id AS request_id'
    ).where(
      Request.arel_table[:requested_pick_up_date].lteq(date_end).and(
        Request.arel_table[:requested_return_date].gt(date_begin)
      )
    ).joins(
      RequestItem.arel_table.join(Request.arel_table).on(
        Request.arel_table[:id].eq(RequestItem.arel_table[:request_id]).and(
          RequestItem.arel_table[:item_id].eq(self[:id]).and(Request.arel_table[:status].in([2, 3]))
        )
      ).join_sources
    ).order(Request.arel_table[:requested_return_date], Request.arel_table[:requested_pick_up_date]).collect {|x| [x.requested_pick_up_date, x.requested_return_date, x.quantity, x.request_id] }
  end

  def max_used_between(date_begin, date_end)
    ranges = conflicting_ranges(date_begin, date_end)

    if ranges.length == 0
      return 0
    end

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
    available - max_used_between(date_begin, date_end) >= qty
  end

  def available
    self[:total] - self[:unavailable]
  end

  def available_date_range(date_begin, date_end)
    return available - max_used_between(date_begin, date_end)
  end

  private
  def enough_total
    if self[:total] < self[:unavailable]
      errors.add(:total, "is too small for unavailable")
    end
  end
end
