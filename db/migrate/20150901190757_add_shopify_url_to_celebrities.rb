class AddShopifyUrlToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :shopify_url, :string
  end
end
