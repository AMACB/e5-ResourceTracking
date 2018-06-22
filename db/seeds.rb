# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'

data = JSON.load File.new("db/seeddata.json")
a = []
data.each do |i|
  a.push(i["category"])
end
cat = a.uniq.sort

categories = Hash.new
cat.each do |c|
  categories[c] = Category.create(name: c, description: c)
end

data.each do |i|
  cat = i["category"]
  cat_id = categories[cat].id
  newitem = Item.create!(category_id: cat_id, name: i["name"], description: i["description"], condition: 4, notes: i["notes"], age: i["age"], price: (i["price"].nil? ? nil : (i["price"]*100).to_i), image: "", total: i["quantity"].nil? ? 0 : i["quantity"])
end


=begin
food = Category.create(name: 'Food', description: 'Things that involve food')
entertainment = Category.create(name: 'Entertainment', description: 'Things that involve entertainment')

i = Item.create([
  {name: 'Popcorn Machine', category_id: food.id, description: "A popcorn machine", condition: 1, notes: "", age: "12+", quantity: 4, price: 2500, image: "https://www.menkind.co.uk/media/catalog/product/cache/49dcd5d85f0fa4d590e132d0368d8132/p/o/popcorn_maker_39933.jpg"},
  {name: 'Hotdog Machine', category_id: food.id, description: "A hotdog machine", condition: 1, notes: "Half of it broke :(", age: "12+", quantity: 1, price: 10000, image: ""},
  {name: 'Gumball Machine', category_id: food.id, description: "A gumball machine", condition: 2, notes: "", age: "8-9", quantity: 1, price: 420, image: ""},
  {name: 'Single Hot Dog', category_id: food.id, description: "A single hot dog", condition: 4, notes: "", age: "5+", quantity: 3, price: 69, image: "https://upload.wikimedia.org/wikipedia/commons/b/b1/Hot_dog_with_mustard.png"},
  {name: 'Bouncy Castle', category_id: entertainment.id, description: "A bouncy castle", condition: 3, notes: "", age: "7+", quantity: 2, price: 15679, image: ""},
  {name: 'Deflated Bouncy Castle', category_id: entertainment.id, description: "A bouncy castle, but deflated", condition: 0, notes: "It's deflated", age: "7+", quantity: 1, price: 15679, image: ""}
])
=end