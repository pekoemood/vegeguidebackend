class RemoveRecipeFkFromIngredientsAndShoppingItems < ActiveRecord::Migration[7.2]
  def change

    remove_foreign_key :ingredients, :recipes if foreign_key_exists?(:ingredients, :recipes)
    remove_foreign_key :shopping_list_items, :recipes if foreign_key_exists?(:shopping_list_items, :recipes)

    change_column_null :ingredients, :recipe_id, true
    change_column_null :shopping_list_items, :recipe_id, true
  end
end
