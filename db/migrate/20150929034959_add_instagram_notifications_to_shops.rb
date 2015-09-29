class AddInstagramNotificationsToShops < ActiveRecord::Migration
  def change
    add_column :celebrities, :youtube_subscriber_threshold, :integer, :default => 5000
    add_column :celebrities, :instagram_follower_threshold, :integer, :default => 2500
    add_column :celebrities, :klout_score_threshold, :integer, :default => 75
  end
end
