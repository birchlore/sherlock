class AddFreebieToCustomer < ActiveRecord::Migration
  def change
  	add_column :customers, :freebie_scan, :boolean, :default => false
  end
end
