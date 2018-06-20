class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|
      t.integer     :status
      t.references  :user
      t.timestamps
    end
  end
end
