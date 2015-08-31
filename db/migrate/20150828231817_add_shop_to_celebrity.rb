class AddShopToCelebrity < ActiveRecord::Migration
  def change
    add_reference :celebrities, :shop, index: true, foreign_key: true
  end
end
