require 'spec_helper'

describe CheckoutItem do

  before(:each) do
    CheckoutItem.destroy_all
  end

  describe '#item' do
    it 'should not allow absence' do
      record = CheckoutItem.new
      record.item = nil
      record.checkout = Checkout.first
      record.quantity = 1

      expect(record).to_not be_valid
    end

    it 'should allow presence' do
      record = CheckoutItem.new
      record.item = Item.first
      record.checkout = Checkout.first
      record.quantity = 1

      expect(record).to be_valid
    end

    it 'should be unique within checkout' do
      c1 = CheckoutItem.create(item: Item.first, checkout: Checkout.first, quantity: 1)
      c2 = CheckoutItem.create(item: Item.first, checkout: Checkout.first, quantity: 1)

      expect(c2).to_not be_valid
    end
  end

  describe '#checkout' do
    it 'should not allow absence' do
      record = CheckoutItem.new
      record.item = Item.first
      record.checkout = nil
      record.quantity = 1

      expect(record).to_not be_valid
    end

    it 'should allow presence' do
      record = CheckoutItem.new
      record.item = Item.first
      record.checkout = Checkout.first
      record.quantity = 1

      expect(record).to be_valid
    end
  end

  describe '#quantity' do
    it 'should not allow zero' do
      record = CheckoutItem.new
      record.item = Item.first
      record.checkout = Checkout.first
      record.quantity = 0

      expect(record).to_not be_valid
    end
  end
end