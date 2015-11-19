class ShopsAddPlan < ActiveRecord::Migration
  def change
    add_column :shops, :plan, :string, default: 'free'
  end
end
