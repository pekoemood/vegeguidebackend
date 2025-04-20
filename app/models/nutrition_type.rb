class NutritionType < ApplicationRecord
  has_many :vegetable_nutrions, dependent: :destroy
  has_many :vegetables, through: :vegetable_nutritions

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true
end
