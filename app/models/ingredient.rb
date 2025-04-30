class Ingredient < ApplicationRecord
  belongs_to :recipe
  has_many :shopping_list_items, dependent: :destroy
end
