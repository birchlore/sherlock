class AddUsersProcessedToShop < ActiveRecord::Migration
  def change
    add_column :shops, :customers_processed, :bigint, default: 0
  end
end
