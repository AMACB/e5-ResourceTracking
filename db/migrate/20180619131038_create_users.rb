class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :email
      t.integer :permission_level, :default => 0
      t.integer :current_checkout_id, :default => nil
      t.string  :password_digest

      t.string  :confirm_token
      t.boolean :email_confirmed, :default => false
      t.timestamps
    end
  end
end
