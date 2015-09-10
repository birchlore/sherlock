class RenameNotificationsToSettings < ActiveRecord::Migration
  def change
    rename_table :notifications, :settings
    add_column :settings, :twitter_follower_threshold, :integer
    add_column :settings, :email_notifications, :boolean
    add_column :settings, :wikipedia_notification, :boolean
    add_column :settings, :imdb_notification, :boolean
    add_reference :settings, :shop_id, index: true
  end 
end
