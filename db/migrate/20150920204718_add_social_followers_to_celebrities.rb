class AddSocialFollowersToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :youtube_followers, :integer
    add_column :celebrities, :instagram_followers, :integer
    rename_column :celebrities, :followers, :twitter_followers
  end
end
