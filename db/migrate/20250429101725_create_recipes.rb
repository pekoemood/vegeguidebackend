class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :instructions
      t.integer :cooking_time
      t.string :difficulty
      t.integer :servings

      t.timestamps
    end
  end
end
