class AddIndexToPrices < ActiveRecord::Migration[7.2]
  def change
    add_index :prices, [ :vegetable_id, :market, :date ], unique: true
  end
end
