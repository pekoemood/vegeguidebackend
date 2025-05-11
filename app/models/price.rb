class Price < ApplicationRecord
  belongs_to :vegetable

  def self.monthly_average_for(vegetable_id)
    where(vegetable_id: vegetable_id)
    .group("DATE_TRUNC('month', date)")
    .select("DATE_TRUNC('month', date) AS month, AVG(price) AS average_price")
    .order("month")
  end

  def self.latest_price_for(vegetable_id)
    where(vegetable_id: vegetable_id)
    .order(date: :desc).first
  end

  def self.compare_last_month(vegetable_id)
    prices = 
    where(vegetable_id: vegetable_id)
    .order(date: :desc)
    .limit(2)
    .offset(0)

    return nil if prices.size < 2

    latest_price = prices[0].price
    previous_price = prices[1].price
    
    change_rate = ((latest_price - previous_price) / previous_price.to_f * 100).round(1)
    change_rate
  end
end
