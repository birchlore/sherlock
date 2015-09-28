class RenameChannelToUsername < ActiveRecord::Migration
  def change
    add_column :celebrities, :youtube_username, :string
  end
end
