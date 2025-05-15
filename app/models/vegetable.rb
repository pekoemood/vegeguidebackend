class Vegetable < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :vegetable_nutritions, dependent: :destroy
  has_many :nutrition_types, through: :vegetable_nutritions

  validates :name, presence: true, uniqueness: true

  def check_season
    seasons.select(&:in_season?)
  end
end
