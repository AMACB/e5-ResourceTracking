class Request < ApplicationRecord
  has_many :request_items

  belongs_to :user
  belongs_to :reviewed_by,    class_name: "User", required: false, foreign_key: "reviewed_by_id"
  belongs_to :checked_in_by,  class_name: "User", required: false, foreign_key: "checked_in_by_id"
  belongs_to :checked_out_by, class_name: "User", required: false, foreign_key: "checked_out_by_id"

  validate :dates_are_valid
  validate :reason_present
  validate :items_available

  validates :status, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Status Codes:
  # 0: Not submitted
  # 1: Submitted, pending approval
  # 2: Approved, pending pickup
  # 3: Picked up, pending return
  # 4: Returned

  scope :returned, -> { where(status: 4) }
  scope :picked_up, -> { where(status: 3) }
  scope :awaiting_pickup, -> { where(status: 2) }
  scope :awaiting_return, -> { where(status: 3) }
  scope :approved, -> { where('status = 2 OR status = 3') }
  scope :pending_approval, -> { where(status: 1) }
  scope :rejected, -> { where(status: 0, rejected: true ) }

  def self.check_for_invalid
    request = Request.pending_approval
    errs = Array.new
    request.each do |r|
      if !r.valid?
        errs << r.errors
        r.status = 0
        if r.save
          r.user.notifications.create(notif_type: "request_invalidated", importance: 4, head: "Your Request was Automatically Rejected", body: "Your recent request for \"#{r.reason}\" was rejected because an item you reserved was checked out by another user. Request ID: #{r.id}")
        else
          raise "Previously valid request was invalid when status was updated to 0 during auto-rejection."
        end
      end
    end
    return errs
  end

  def reason_present
    unless self.status == 0
      if self.reason.blank?
        errors.add :reason, "can't be blank"
      end
    end
  end

  def errors_on_request
    self.status = 1
    self.reason = 'foo'
    self.requested_pick_up_date = Date.today + 1.days
    self.requested_return_date = Date.today + 2.days
    self.valid?
    return self.errors
  end

  def dates_are_valid
    unless self.status == 0
      if self.requested_pick_up_date.blank?
        errors.add :requested_pick_up_date, "can't be blank"
      elsif self.requested_pick_up_date < Time.zone.today
        errors.add :requested_pick_up_date, "can't be in the past"
      end

      if self.requested_return_date.blank?
        errors.add :requested_return_date, "can't be blank"
      elsif self.requested_return_date < Time.zone.today
        errors.add :requested_return_date, "can't be in the past"
      end

      if self.requested_return_date.present? and self.requested_pick_up_date.present? and self.requested_return_date < self.requested_pick_up_date
        errors.add :requested_return_date, "must be after the need by date"
      end
    end
  end

  def items_available
    if self.status == 1
      request_items.each do |ci|
        if !ci.item.is_available_from?(requested_pick_up_date, requested_return_date, ci.quantity)
          errors.add :request_items, "contains a item that is not available: " + ci.quantity.to_s + " x " + ci.item.name
        end
      end
    end
  end
end
