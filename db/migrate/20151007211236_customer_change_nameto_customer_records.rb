class CustomerChangeNametoCustomerRecords < ActiveRecord::Migration
  def change
  	rename_table :customers, :customer_records
  end
end
