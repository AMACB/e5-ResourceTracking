class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string      :name
      t.text        :description
      t.text        :notes
      t.string      :age
      t.integer     :condition, default: 4
      t.integer     :price
      t.string      :image

      t.text        :tags

      t.integer     :available, default: 0
      t.integer     :checked_out, default: 0
      t.integer     :unavailable, default: 0
      t.integer     :total, default: 0

      t.references  :category
      t.timestamps
    end
  end
end
