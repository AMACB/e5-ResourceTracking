require 'spec_helper'

describe Notification do

  subject {
    described_class.new(user: User.new, importance: 0, notif_type: "foo", head: "bar", body: "baz")
  }

  describe '#user' do
    it 'should not allow blank' do
      subject.user = nil

      expect(subject).to_not be_valid
    end
  end

  describe '#importance' do
    it 'should not allow blank' do
      subject.importance = nil

      expect(subject).to_not be_valid
    end

    it 'should not allow negative' do
      subject.importance = -1

      expect(subject).to_not be_valid
    end

    it 'should allow positive' do
      subject.importance = 2

      expect(subject).to be_valid
    end

    it 'should not allow greater than or equal to five' do
      subject.important = 5

      expect(subject).to_not be_valid
    end
  end

  describe '#notif_type' do
    it 'should not allow blank' do
      subject.notif_type = nil

      expect(subject).to_not be_valid
    end
  end

  describe '#head' do
    it 'should not allow blank' do
      subject.head = nil

      expect(subject).to_not be_valid
    end
  end

  describe '#body' do
    it 'should not allow blank' do
      subject.body = nil

      expect(subject).to_not be_valid
    end
  end
end