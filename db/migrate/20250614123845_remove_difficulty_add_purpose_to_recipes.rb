class RemoveDifficultyAddPurposeToRecipes < ActiveRecord::Migration[7.2]
  def change
    remove_column :recipes, :difficulty, :string
    add_column :recipes, :purpose, :string
  end
end
