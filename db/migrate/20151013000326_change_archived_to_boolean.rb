class ChangeArchivedToBoolean < ActiveRecord::Migration
  def change
  	  remove_column :customers, :archived, :string
  	  add_column :customers, :archived, :boolean, :default => false
  end
end
