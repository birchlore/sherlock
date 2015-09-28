class AddYoutubeViewsToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :youtube_views, :integer
  end
end
