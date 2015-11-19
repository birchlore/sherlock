class ShopChangeInstalledDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :shops, :installed, :boolean, default: false
  end
end
