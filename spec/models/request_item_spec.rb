require 'spec_helper'

describe RequestItem do

  subject {
    described_class.new(item: Item.new, request: Request.new, quantity: 1)
  }

  before(:each) do
    RequestItem.destroy_all
  end

  describe '#item' do
    it 'should not allow absence' do
      subject.item = nil

      expect(subject).to_not be_valid
    end

    it 'should allow presence' do
      subject.item = Item.new

      expect(subject).to be_valid
    end

=begin
    it 'should be unique within checkout' do
      c1 = RequestItem.create(item: Item.first, checkout: Checkout.first, quantity: 1)
      c2 = RequestItem.create(item: Item.first, checkout: Checkout.first, quantity: 1)

      expect(c2).to_not be_valid
    end
=end
  end

  describe '#request' do
    it 'should not allow absence' do
      subject.request = nil

      expect(subject).to_not be_valid
    end

    it 'should allow presence' do
      subject.request = Request.new

      expect(subject).to be_valid
    end
  end

  describe '#quantity' do
    it 'should not allow zero' do
      subject.quantity = 0

      expect(subject).to_not be_valid
    end
    
    it 'should not allow negative' do
      subject.quantity = -1

      expect(subject).to_not be_valid
    end
  end
end