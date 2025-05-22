class ShoppingListItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :recipe, optional: true
  belongs_to :ingredient
  after_destroy :cleanup_ingredient

  private

    def cleanup_ingredient
      ingredient.reload

      if ingredient.shopping_list_items.empty? && ingredient.recipe.nil?
        ingredient.destroy
      end
    end
end
