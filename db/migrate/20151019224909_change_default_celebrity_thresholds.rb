class ChangeDefaultCelebrityThresholds < ActiveRecord::Migration
  def change
  	change_column :shops, :twitter_follower_threshold, :integer, :default => 1000
  	change_column :shops, :youtube_subscriber_threshold, :integer, :default => 1000
  	change_column :shops, :instagram_follower_threshold, :integer, :default => 1000
  end
end

