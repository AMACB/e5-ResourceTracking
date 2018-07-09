class AddRejectionToCheckout < ActiveRecord::Migration[5.2]
  def change
    add_column :checkouts, :rejected, :boolean, default: false
    add_column :checkouts, :rejected_msg, :text
  end
end
