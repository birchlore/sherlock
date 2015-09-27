class ChangeDefaultValueOfTwitterFollowers < ActiveRecord::Migration
  def change
    change_column :celebrities, :twitter_followers, :integer, :default => nil
  end
end
