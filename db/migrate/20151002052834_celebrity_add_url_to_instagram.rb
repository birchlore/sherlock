class CelebrityAddUrlToInstagram < ActiveRecord::Migration
  def change
    add_column :celebrities, :instagram_url, :string
  end
end
