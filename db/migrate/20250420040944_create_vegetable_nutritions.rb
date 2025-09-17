class CreateVegetableNutritions < ActiveRecord::Migration[7.2]
  def change
    create_table :vegetable_nutritions do |t|
      t.references :vegetable, null: false, foreign_key: true
      t.references :nutrition_type, null: false, foreign_key: true
      t.decimal :amount, precision: 6, scale: 2

      t.timestamps
    end
    
    add_index :vegetable_nutritions, [:vegetable_id, :nutrition_type_id], unique: true
  end
end
