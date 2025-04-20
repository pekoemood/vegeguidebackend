class VegetableNutrition < ApplicationRecord
  belongs_to :vegetable
  belongs_to :nutrition_type

  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :nutrition_type_id, uniqueness: { scope: :vegetable_id }
end
