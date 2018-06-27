class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references  :user
      t.datetime    :read_at, default: nil
      t.string      :notif_type
      t.string      :head
      t.text        :body
      t.timestamps
    end
  end
end
