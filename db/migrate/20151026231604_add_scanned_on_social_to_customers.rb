class AddScannedOnSocialToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :scanned_on_social, :boolean, :default => false
  end
end
