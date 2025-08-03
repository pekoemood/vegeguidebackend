class ShoppingListItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :recipe, optional: true
  belongs_to :ingredient
  after_destroy :cleanup_ingredient

  validates :shopping_list, presence: true
  validates :ingredient, presence: true

  private

    def cleanup_ingredient
      ingredient.reload

      recipe_exists = ingredient.recipe_id.present? && Recipe.exists?(ingredient.recipe_id)
      
      if ingredient.shopping_list_items.empty? && !recipe_exists
        ingredient.destroy
      end
    end
end
