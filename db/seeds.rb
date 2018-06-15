# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

food = Category.create(name: 'Food', description: 'Things that involve food')
entertainment = Category.create(name: 'Entertainment', description: 'Things that involve entertainment')

i = Item.create([
  {name: 'Popcorn Machine', category_id: food.id, description: "A popcorn machine", condition: 1},
  {name: 'Hotdog Machine', category_id: food.id, description: "A hotdog machine", condition: 1},
  {name: 'Gumball Machine', category_id: food.id, description: "A gumball machine", condition: 2},
  {name: 'Single Hot Dog', category_id: food.id, description: "A single hot dog", condition: 4},
  {name: 'Bouncy Castle', category_id: entertainment.id, description: "A bouncy castle", condition: 3},
  {name: 'Deflated Bouncy Castle', category_id: entertainment.id, description: "A bouncy castle, but deflated", condition: 0}
])