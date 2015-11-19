class ShopRemoveCustomersProcessed < ActiveRecord::Migration
  def change
    remove_column :shops, :customers_processed, :integer
  end
end
