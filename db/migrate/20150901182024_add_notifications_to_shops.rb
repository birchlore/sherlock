class AddNotificationsToShops < ActiveRecord::Migration
  def change
    add_column :shops, :notifications, :boolean, default: true
  end
end
