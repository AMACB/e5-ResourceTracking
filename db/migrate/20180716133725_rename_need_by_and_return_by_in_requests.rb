class RenameNeedByAndReturnByInRequests < ActiveRecord::Migration[5.2]
  def change
    rename_column :requests, :need_by, :requested_pick_up_date
    rename_column :requests, :return_by, :requested_return_date
  end
end
