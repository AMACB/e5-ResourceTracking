class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string      :name
      t.text        :description
      t.text        :notes
      t.string      :age
      t.integer     :condition
      t.integer     :quantity
      t.integer     :price
      t.string      :image

      t.references  :category
      t.timestamps
    end
  end
end
