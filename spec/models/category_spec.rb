require 'spec_helper'

describe Category do

  describe '#items' do
    it 'should add items' do
      c = Category.create(name: 'foo', description: 'bar')
      i1 = Item.create(name: 'foo', description: 'bar', category: c)
      i2 = Item.create(name: 'baz', description: 'qux', category: c)
      i3 = Item.create(name: 'foo', description: 'bar', category: c)
      i4 = Item.create(name: 'baz', description: 'qux', category: c)

      c.items.size.should eq(4)
    end
  end 
end