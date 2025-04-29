class ShoppingListItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :recipe
  belongs_to :ingredient
end
