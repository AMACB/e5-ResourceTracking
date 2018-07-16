class AddPasswordResetTokenExpiresAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_reset_token_expires_at, :datetime
  end
end
