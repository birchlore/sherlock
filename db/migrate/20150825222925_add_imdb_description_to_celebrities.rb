class AddImdbDescriptionToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :imdb_description, :string
  end
end
