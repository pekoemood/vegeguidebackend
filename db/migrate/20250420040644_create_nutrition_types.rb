class CreateNutritionTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :nutrition_types do |t|
      t.string :name, null: false
      t.string :unit, null: false

      t.timestamps
    end

    add_index :nutrition_types, :name, unique: true
  end
end
