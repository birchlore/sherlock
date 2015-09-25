class AddDescriptionsToCelebrities < ActiveRecord::Migration
  def change
  	add_column :celebrities, :twitter_description, :string
  	add_column :celebrities, :twitter_url, :string
  	add_column :celebrities, :youtube_description, :string
  	add_column :celebrities, :youtube_url, :string
  	add_column :celebrities, :angellist_description, :string
  	add_column :celebrities, :angellist_url, :string
  	add_column :celebrities, :linkedin_description, :string
  	add_column :celebrities, :linkedin_url, :string
  	add_column :celebrities, :instagram_username, :string
  end
end
