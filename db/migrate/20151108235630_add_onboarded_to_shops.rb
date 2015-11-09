class AddOnboardedToShops < ActiveRecord::Migration
  def change
  	add_column :shops, :onboarded, :boolean, :default => false
  end
end
