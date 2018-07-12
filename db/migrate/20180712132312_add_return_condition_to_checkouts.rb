class AddReturnConditionToCheckouts < ActiveRecord::Migration[5.2]
  def change
    add_column :checkouts, :return_condition, :string
  end
end
