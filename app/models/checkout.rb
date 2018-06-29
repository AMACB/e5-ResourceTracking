class Checkout < ApplicationRecord
  has_many :checkout_items
  belongs_to :user
  validate :dates_are_valid

  scope :approved, -> { where('status >= 2') }
  scope :pending_approval, -> { where(status: 1) }

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
end
