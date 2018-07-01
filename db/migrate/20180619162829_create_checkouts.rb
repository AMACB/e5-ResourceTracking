class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|
      t.integer     :status, default: 0
      t.datetime    :checkout_time

      t.datetime    :picked_up_at
      t.datetime    :returned_at

      t.text        :reason
      t.text        :notes

      t.date        :need_by
      t.date        :return_by
      t.references  :user
      t.timestamps
    end
  end
end
