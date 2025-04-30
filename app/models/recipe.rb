class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  has_many :shopping_list_items, dependent: :destroy
  has_many :shopping_lists, through: :shopping_list_items
end
