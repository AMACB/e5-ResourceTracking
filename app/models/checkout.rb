class Checkout < ApplicationRecord
  has_many :checkout_items
  belongs_to :user
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
  scope :approved, -> { where('status = 2 OR status = 3') }
  scope :pending_approval, -> { where(status: 1) }

  def self.check_for_invalid
    checkouts = Checkout.pending_approval
    errs = Array.new
    checkouts.each do |c|
      if !c.valid?
        errs << c.errors
        c.status = 0
        if c.save
          c.user.notifications.create(notif_type: "checkout_invalidated", importance: 4, head: "Your Request was Automatically Rejected", body: "Your recent checkout for \"#{c.reason}\" was rejected because an item you reserved was checked out by another user. Checkout ID: #{c.id}")
        else
          raise "Previously valid checkout was invalid when status was updated to 0 during auto-rejection."
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

  def errors_on_checkout
    self.status = 1
    self.reason = 'foo'
    self.valid?
    return self.errors
  end

  def dates_are_valid
    unless self.status == 0
      if self.need_by.blank?
        errors.add :need_by, "can't be blank"
      elsif self.need_by < Time.zone.today
        errors.add :need_by, "can't be in the past"
      end

      if self.return_by.blank?
        errors.add :return_by, "can't be blank"
      elsif self.return_by < Time.zone.today
        errors.add :return_by, "can't be in the past"
      end

      if self.return_by.present? and self.need_by.present? and self.return_by < self.need_by
        errors.add :return_by, "must be after the need by date"
      end
    end
  end

  def items_available
    if self.status == 1
      checkout_items.each do |ci|
        puts need_by, return_by, ci.quantity
        if !ci.item.is_available_from?(need_by, return_by, ci.quantity)
          errors.add :checkout_items, "contains a item that is not available: " + ci.quantity.to_s + " x " + ci.item.name
        end
      end
    end
  end
end
