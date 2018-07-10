require 'json'

namespace :items do
  task :add_tags_to_db => :environment do
    data = JSON.load File.new(Rails.root.join('db','tags.json'))
    data.each do |x|
      id = x["id"]
      tags = x["tags"]
      i = Item.find(id)
      i.tags = tags.join(",").downcase
      i.save
    end
  end
end
