require 'spec_helper'

describe Item do

  subject {
    described_class.new(name: 'foo', description: 'bar', category: Category.new)
  }


  describe '#name' do
    it 'should not allow blank' do
      subject.name = nil

      expect(subject).to_not be_valid
    end

    it 'should allow non-blank' do
      subject.name = 'foo'

      expect(subject).to be_valid
    end
  end

  describe '#category' do
    it 'should not allow blank' do
      subject.category = nil

      expect(subject).to_not be_valid
    end
  end

  describe '#description' do
    it 'should not allow blank' do
      subject.description = nil

      expect(subject).to_not be_valid
    end
  end

  describe '#availability' do
    it 'should default to zero' do
      expect(subject.unavailable).to eq(0)
      expect(subject.total).to eq(0)
    end

    it 'should allow all zero' do
      subject.unavailable = 0
      subject.total = 0

      expect(subject).to be_valid
    end

    it 'should not allow unavailable negative' do
      subject.unavailable = -1

      expect(subject).to_not be_valid
    end

    it 'should not allow total negative' do
      subject.total = -1

      expect(subject).to_not be_valid
    end

    it 'should not allow unavailable > total' do
      subject.total = 2
      subject.unavailable = 3

      expect(subject).to_not be_valid
    end
  end
end