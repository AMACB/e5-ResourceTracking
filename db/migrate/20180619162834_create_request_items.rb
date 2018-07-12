class CreateRequestItems < ActiveRecord::Migration[5.2]
  def change
    create_table :request_items do |t|
      t.references  :item
      t.references  :checkout
      t.integer     :quantity
      t.timestamps
    end
  end
end
