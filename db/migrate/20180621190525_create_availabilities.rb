class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.integer     :available, default: 0
      t.integer     :checked_out, default: 0
      t.integer     :unavailable, default: 0
      t.integer     :total, default: 0
      t.integer     :item_id
      t.timestamps
    end
  end
end
