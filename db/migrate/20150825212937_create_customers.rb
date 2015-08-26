class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
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
