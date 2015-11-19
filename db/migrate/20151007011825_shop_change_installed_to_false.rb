class ShopChangeInstalledToFalse < ActiveRecord::Migration
  def change
    change_column :shops, :installed, :boolean, default: true
  end
end
