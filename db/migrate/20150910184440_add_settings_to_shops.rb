class AddSettingsToShops < ActiveRecord::Migration
  def change
  	rename_column :shops, :notifications, :email_notifications
    add_column :shops, :wikipedia_notification, :boolean,  :default => true
    add_column :shops, :imdb_notification, :boolean,  :default => false
  end
end
