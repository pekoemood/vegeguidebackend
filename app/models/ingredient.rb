class Ingredient < ApplicationRecord
  belongs_to :recipe, optional: true
  has_many :shopping_list_items, dependent: :destroy
end
