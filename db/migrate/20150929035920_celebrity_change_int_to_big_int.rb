class CelebrityChangeIntToBigInt < ActiveRecord::Migration
  def change
    change_column :celebrities, :twitter_followers, :bigint
    change_column :celebrities, :youtube_subscribers, :bigint
    change_column :celebrities, :instagram_followers, :bigint
    change_column :celebrities, :klout_id, :bigint
    change_column :celebrities, :youtube_views, :bigint
  end
end
