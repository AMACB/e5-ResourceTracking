require 'spec_helper'

describe Request do

  subject {
    described_class.new(user: User.new, reason: "foo", status: 1, requested_pick_up_date: Time.zone.today + 1.days, requested_return_date: Time.zone.today + 3.days)
  }

  describe '#status' do
    it 'should not allow negative' do
      subject.status = -1

      expect(subject).to_not be_valid
    end

=begin
    it 'should allow scopes' do
      t = Time.zone.today
      Request.destroy_all
      Request.create(user: User.first, reason: "foo", status: 0, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)
      Request.create(user: User.first, reason: "foo", status: 1, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)
      Request.create(user: User.first, reason: "foo", status: 1, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)
      Request.create(user: User.first, reason: "foo", status: 2, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)
      Request.create(user: User.first, reason: "foo", status: 3, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)
      Request.create(user: User.first, reason: "foo", status: 4, requested_pick_up_date: Time.zone.now + 1.days, requested_return_date: Time.zone.now + 2.days)

      expect(Request.pending_approval.size).to eq(2)
      expect(Request.approved.size).to eq(2)
      expect(Request.picked_up.size).to eq(1)
      expect(Request.returned.size).to eq(1)
    end
=end
  end


  describe '#reason' do
    it 'should not allow blank' do
      subject.reason = nil

      expect(subject).to_not be_valid
    end


  end

  describe '#dates' do
    it 'should not allow requested_pick_up_date in the past' do
      subject.requested_pick_up_date = Time.zone.now - 2.days
      subject.requested_return_date = Time.zone.now + 2.days

      expect(subject).to_not be_valid
    end

    it 'should not allow requested_return_date in the past' do
      subject.requested_pick_up_date = Time.zone.now + 2.days
      subject.requested_return_date = Time.zone.now - 2.days

      expect(subject).to_not be_valid
    end

    it 'should not allow requested_pick_up_date after requested_return_date' do
      subject.requested_pick_up_date = Time.zone.now + 3.days
      subject.requested_return_date = Time.zone.now + 2.days

      expect(subject).to_not be_valid
    end

    it 'should allow requested_pick_up_date equal requested_return_date' do
      subject.requested_pick_up_date = Time.zone.now + 2.days
      subject.requested_return_date = Time.zone.now + 2.days

      expect(subject).to be_valid
    end

    it 'should allow today' do
      subject.requested_pick_up_date = Time.zone.now
      subject.requested_return_date = Time.zone.now

      expect(subject).to be_valid
    end
  end
end