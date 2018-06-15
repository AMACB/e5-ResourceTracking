class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string      :name
      t.text        :description
      t.integer     :condition
      t.references  :category
      t.timestamps
    end
  end
end
