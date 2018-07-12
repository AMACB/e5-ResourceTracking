class AddForeignKeysToCheckouts < ActiveRecord::Migration[5.2]
  def change
    add_column :checkouts, :reviewed_by_id, :integer
    add_column :checkouts, :checked_in_by_id, :integer
    add_column :checkouts, :checked_out_by_id, :integer
  end
end
