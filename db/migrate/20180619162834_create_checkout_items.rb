class CreateCheckoutItems < ActiveRecord::Migration[5.2]
  def change
    create_table :checkout_items do |t|
      t.references  :item
      t.references  :checkout
      t.integer     :quantity
      t.timestamps
    end
  end
end
