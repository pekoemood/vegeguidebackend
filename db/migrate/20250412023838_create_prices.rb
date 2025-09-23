class CreatePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :prices do |t|
      t.references :vegetable, null: false, foreign_key: true
      t.integer :price, null: false
      t.string :market, null: false
      t.date :date, null: false
      t.decimal :price_variation, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
