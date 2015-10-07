class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
    	t.references :shop
    	t.integer :count
    	t.date :date
    end
  end
end
