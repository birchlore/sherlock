class AddKloutIdToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :klout_id, :integer
    add_column :celebrities, :klout_score, :float
    add_column :celebrities, :klout_url, :string
  end
end
