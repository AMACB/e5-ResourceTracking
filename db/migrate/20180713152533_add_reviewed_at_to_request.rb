class AddReviewedAtToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :reviewed_at, :datetime
  end
end
