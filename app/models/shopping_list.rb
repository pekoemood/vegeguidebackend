class ShoppingList < ApplicationRecord
  belongs_to :user
  has_many :shopping_list_items, dependent: :destroy
  has_many :recipes, through: :shopping_list_items
  has_many :ingredients, through: :shopping_list_items

  def updated_days_ago
    latest_update = shopping_list_items.maximum(:created_at)
    return nil if latest_update.nil?
    days = (Time.zone.today - latest_update.to_date).to_i
    days.zero? ? '今日' : "#{days}日前"
  end
end
