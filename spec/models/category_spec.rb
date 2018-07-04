require 'spec_helper'

describe Category do

  subject {
    described_class.new(name: 'foo')
  }

  describe '#name' do
    it 'should not allow blank' do
      subject.name = nil

      expect(subject).to_not be_valid
    end
  end

=begin
  describe '#items' do
    it 'should add items' do
      c = Category.create(name: 'foo', description: 'bar')
      i1 = Item.create(name: 'foo', description: 'bar', category: c)
      i2 = Item.create(name: 'baz', description: 'qux', category: c)
      i3 = Item.create(name: 'foo', description: 'bar', category: c)
      i4 = Item.create(name: 'baz', description: 'qux', category: c)

      expect(c.items.size).to eq(4)
    end
  end
=end
end