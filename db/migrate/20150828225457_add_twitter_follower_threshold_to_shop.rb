class AddTwitterFollowerThresholdToShop < ActiveRecord::Migration
  def change
    add_column :shops, :twitter_follower_threshold, :integer, :default => 10000
  end
end
