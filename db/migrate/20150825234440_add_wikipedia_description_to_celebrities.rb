class AddWikipediaDescriptionToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :wikipedia_description, :string
  end
end
