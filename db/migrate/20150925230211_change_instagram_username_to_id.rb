class ChangeInstagramUsernameToId < ActiveRecord::Migration
  def change
    rename_column :celebrities, :instagram_username, :instagram_id
  end
end
