class CelebrityAddShopifyId < ActiveRecord::Migration
  def change
  	add_column :celebrities, :shopify_id, :integer
  end
end
