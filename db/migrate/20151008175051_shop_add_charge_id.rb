class ShopAddChargeId < ActiveRecord::Migration
  def change
  	add_column :shops, :charge_id, :integer
  end
end
