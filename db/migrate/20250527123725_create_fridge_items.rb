class CreateFridgeItems < ActiveRecord::Migration[7.2]
  def change
    create_table :fridge_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.decimal :amount
      t.string :unit
      t.string :category
      t.date :expire_date

      t.timestamps
    end
  end
end
