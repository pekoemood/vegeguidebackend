class Vegetable < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :vegetable_nutritions, dependent: :destroy
  has_many :nutrition_types, through: :vegetable_nutritions

  validates :name, presence: true, uniqueness: true
  

  def in_season?
    current_month = Date.today.month
    seasons.any? do |season|
      if season.start_month <= season.end_month
        season.start_month <= current_month && current_month <= season.end_month
      else
        current_month >= season.start_month || current_month <= season.end_month
      end
    end
  end
end
