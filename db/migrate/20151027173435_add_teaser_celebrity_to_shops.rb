class AddTeaserCelebrityToShops < ActiveRecord::Migration
  def change
    add_column :shops, :teaser_celebrity, :boolean, default: false
  end
end
