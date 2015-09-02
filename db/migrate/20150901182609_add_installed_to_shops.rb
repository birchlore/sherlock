class AddInstalledToShops < ActiveRecord::Migration
  def change
    add_column :shops, :installed, :boolean, :default => false
  end
end
