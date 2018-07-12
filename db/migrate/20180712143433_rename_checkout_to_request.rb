class RenameCheckoutToRequest < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :current_checkout_id, :current_request_id

    rename_table :checkouts, :requests
    rename_table :checkout_items, :request_items
    rename_column :request_items, :checkout_id, :request_id
  end
end
