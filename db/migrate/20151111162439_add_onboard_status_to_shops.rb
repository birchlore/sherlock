class AddOnboardStatusToShops < ActiveRecord::Migration
  def change
    add_column :shops, :onboard_status, :string
  end
end
