class CreateRecipeSteps < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number
      t.text :description

      t.timestamps
    end

    add_index :recipe_steps, [ :recipe_id, :step_number ], unique: true
  end
end
