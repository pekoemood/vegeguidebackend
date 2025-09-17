class AddRecipeCategoryToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :recipe_category, :string
    add_column :recipes, :calorie, :integer
    add_column :recipes, :cooking_method, :string
  end
end
