class CustomerRecordsChangeCountDefault < ActiveRecord::Migration
  def change
  	change_column :customer_records, :count, :integer, :default=> 0
  end
end
