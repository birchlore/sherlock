class AddFieldsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :email, :string
    add_column :customers, :imdb_url, :string
    add_column :customers, :imdb_bio, :string
    add_column :customers, :wikipedia_url, :string
    add_column :customers, :wikipedia_bio, :string
    add_column :customers, :twitter_url, :string
    add_column :customers, :twitter_bio, :string
    add_column :customers, :twitter_followers, :bigint
    add_column :customers, :youtube_url, :string
    add_column :customers, :youtube_bio, :string
    add_column :customers, :youtube_subscribers, :bigint
    add_column :customers, :youtube_views, :bigint
    add_column :customers, :youtube_username, :string
    add_column :customers, :angellist_bio, :string
    add_column :customers, :angellist_url, :string
    add_column :customers, :linkedin_bio, :string
    add_column :customers, :linkedin_url, :string
    add_column :customers, :klout_id, :integer
    add_column :customers, :klout_score, :integer
    add_column :customers, :klout_url, :string
    add_column :customers, :instagram_followers, :bigint
    add_column :customers, :instagram_id, :string
    add_column :customers, :instagram_url, :string
    add_column :customers, :status, :string, default: 'active'
    add_column :customers, :shopify_url, :string
    add_column :customers, :type, :string, default: 'regular'
  end
end
