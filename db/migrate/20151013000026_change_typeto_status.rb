class ChangeTypetoStatus < ActiveRecord::Migration
  def change
    rename_column :customers, :status, :archived
    rename_column :customers, :type, :status
  end
end
