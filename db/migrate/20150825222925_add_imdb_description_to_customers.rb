class AddImdbDescriptionToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :imdb_description, :string
  end
end
