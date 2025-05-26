class ShoppingList < ApplicationRecord
  belongs_to :user
  has_many :shopping_list_items, dependent: :destroy
  has_many :recipes, through: :shopping_list_items
  has_many :ingredients, through: :shopping_list_items

  def updated_days_ago
    return nil if updated_at.nil?
    days = (Time.zone.today - updated_at.to_date).to_i
    days.zero? ? '今日' : "#{days}日前"
  end
end
