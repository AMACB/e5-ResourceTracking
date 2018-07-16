class RenameRejectedMsgInRequests < ActiveRecord::Migration[5.2]
  def change
    rename_column :requests, :rejected_msg, :review_notes
  end
end
