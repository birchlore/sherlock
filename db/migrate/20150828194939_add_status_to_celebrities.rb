class AddStatusToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :status, :string, default: "active"
  end
end
