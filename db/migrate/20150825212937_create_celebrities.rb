class CreateCelebrities < ActiveRecord::Migration
  def change
    create_table :celebrities do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :imdb_url
      t.string :wikipedia_url
      t.integer :followers, :default=> 0
      t.string :industry
      t.timestamps null: false
    end
  end
end
