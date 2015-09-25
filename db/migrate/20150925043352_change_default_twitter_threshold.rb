class ChangeDefaultTwitterThreshold < ActiveRecord::Migration
  def change
    change_column_default :shops, :twitter_follower_threshold, 2500
  end
end
