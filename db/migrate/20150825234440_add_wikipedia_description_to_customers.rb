class AddWikipediaDescriptionToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :wikipedia_description, :string
  end
end
