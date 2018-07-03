require 'spec_helper'

describe Checkout do

  describe '#status' do
    it 'should not allow negative' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = -1
      record.need_by = t + 1.days
      record.return_by = t + 2.days

      expect(record).to_not be_valid
    end

    it 'should allow scopes' do
      t = Time.zone.today
      Checkout.destroy_all
      Checkout.create(user: User.first, reason: "foo", status: 0, need_by: t + 1.days, return_by: t + 2.days)
      Checkout.create(user: User.first, reason: "foo", status: 1, need_by: t + 1.days, return_by: t + 2.days)
      Checkout.create(user: User.first, reason: "foo", status: 1, need_by: t + 1.days, return_by: t + 2.days)
      Checkout.create(user: User.first, reason: "foo", status: 2, need_by: t + 1.days, return_by: t + 2.days)
      Checkout.create(user: User.first, reason: "foo", status: 3, need_by: t + 1.days, return_by: t + 2.days)
      Checkout.create(user: User.first, reason: "foo", status: 4, need_by: t + 1.days, return_by: t + 2.days)

      expect(Checkout.pending_approval.size).to eq(2)
      expect(Checkout.approved.size).to eq(2)
      expect(Checkout.picked_up.size).to eq(1)
      expect(Checkout.returned.size).to eq(1)
    end
  end


  describe '#reason' do
    it 'should not allow blank' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = nil
      record.status = 1
      record.need_by = t + 1.days
      record.return_by = t + 2.days

      expect(record).to_not be_valid
    end

    it 'should allow non-blank' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t + 1.days
      record.return_by = t + 2.days

      expect(record).to be_valid
    end
  end

  describe '#dates' do
    it 'should not allow need_by in the past' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t - 1.days
      record.return_by = t + 1.days

      expect(record).to_not be_valid
    end

    it 'should not allow return_by in the past' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t + 1.days
      record.return_by = t - 1.days

      expect(record).to_not be_valid
    end

    it 'should not allow need_by after return_by' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t + 2.days
      record.return_by = t + 1.days

      expect(record).to_not be_valid
    end

    it 'should not allow need_by equal return_by' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t + 2.days
      record.return_by = t + 2.days

      expect(record).to be_valid
    end

    it 'should not allow today' do
      t = Time.zone.today
      record = Checkout.new
      record.user = User.first
      record.reason = "foo"
      record.status = 1
      record.need_by = t
      record.return_by = t

      expect(record).to be_valid
    end
  end
end