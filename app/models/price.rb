class Price < ApplicationRecord
  belongs_to :vegetable

  scope :vegetable_ids_with_price_drop, -> {
    subquery = <<-SQL.squish
      WITH ranked_prices AS (
        SELECT
          vegetable_id,
          price,
          ROW_NUMBER() OVER (PARTITION BY vegetable_id ORDER BY date DESC) AS rn
        FROM prices
      ),
      latest_two_prices AS (
        SELECT
          p1.vegetable_id,
          p1.price AS latest_price,
          p2.price AS previous_price
        FROM ranked_prices p1
        LEFT JOIN ranked_prices p2
          ON p1.vegetable_id = p2.vegetable_id AND p2.rn = 2
        WHERE p1.rn = 1
      )
      SELECT vegetable_id FROM latest_two_prices
      WHERE previous_price IS NOT NULL AND latest_price < previous_price
    SQL

    # サブクエリ結果のvegetable_idを配列で返す
    Price.connection.select_values(subquery)
  }

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
