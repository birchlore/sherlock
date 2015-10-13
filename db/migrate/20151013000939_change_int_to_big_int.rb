class ChangeIntToBigInt < ActiveRecord::Migration
  def change
  	change_column :customers, :klout_id, :bigint
  	change_column :customers, :shopify_id, :bigint
  end
end
