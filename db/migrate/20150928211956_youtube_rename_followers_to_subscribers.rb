class YoutubeRenameFollowersToSubscribers < ActiveRecord::Migration
  def change
    rename_column :celebrities, :youtube_followers, :youtube_subscribers
  end
end
