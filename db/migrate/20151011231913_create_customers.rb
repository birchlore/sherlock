class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :shopify_id
      t.references :shop
      t.timestamps null: false
    end
  end
end
