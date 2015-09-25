class ChangeDescriptionsToBio < ActiveRecord::Migration
  def change
    rename_column :celebrities, :imdb_description, :imdb_bio
    rename_column :celebrities, :wikipedia_description, :wikipedia_bio
    rename_column :celebrities, :twitter_description, :twitter_bio
    rename_column :celebrities, :youtube_description, :youtube_bio
    rename_column :celebrities, :angellist_description, :angellist_bio
    rename_column :celebrities, :linkedin_description, :linkedin_bio
  end
end