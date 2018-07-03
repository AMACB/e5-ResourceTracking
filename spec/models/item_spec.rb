require 'spec_helper'

describe Item do

  describe '#name' do
    it 'should not allow blank' do
      record = Item.new
      record.name = nil
      record.description = 'foo'
      record.category = Category.first

      expect(record).to_not be_valid
    end

    it 'should allow non-blank' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      expect(record).to be_valid
    end
  end

  describe '#category' do
    it 'should not allow blank' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = nil

      expect(record).to_not be_valid
    end
  end

  describe '#description' do
    it 'should not allow blank' do
      record = Item.new
      record.name = 'bar'
      record.description = nil
      record.category = Category.first

      expect(record).to_not be_valid
    end
  end

  describe '#availability' do
    it 'should allow all zero' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 0
      record.checked_out = 0
      record.total = 0

      expect(record).to be_valid
    end

    it 'should not allow unavailable negative' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = -1
      record.checked_out = 0
      record.total = 0

      expect(record).to_not be_valid
    end

    it 'should not allow checked_out negative' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 0
      record.checked_out = -1
      record.total = 0

      expect(record).to_not be_valid
    end

    it 'should not allow total negative' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 0
      record.checked_out = -1
      record.total = 0

      expect(record).to_not be_valid
    end

    it 'should not allow available negative when unavailable > total' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 2
      record.checked_out = 0
      record.total = 1

      expect(record).to_not be_valid
    end

    it 'should not allow available negative when checked_out > total' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 0
      record.checked_out = 2
      record.total = 1

      expect(record).to_not be_valid
    end

    it 'should allow available positive' do
      record = Item.new
      record.name = 'bar'
      record.description = 'foo'
      record.category = Category.first

      record.unavailable = 1
      record.checked_out = 0
      record.total = 2

      expect(record).to be_valid
    end
  end
end