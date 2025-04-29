class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients
  has_many :recipe_steps
  has_many :shopping_list_items
end
