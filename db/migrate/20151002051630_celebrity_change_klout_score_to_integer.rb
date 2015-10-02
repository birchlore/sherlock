class CelebrityChangeKloutScoreToInteger < ActiveRecord::Migration
  def change
    change_column :celebrities, :klout_score, :integer
  end
end
