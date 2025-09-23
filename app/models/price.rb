class Price < ApplicationRecord
  belongs_to :vegetable
  validates :price, :market, :date, presence: true

  scope :vegetable_ids_with_price_drop, -> {
    Rails.cache.fetch("price_drop_vegetable_ids", expires_in: 1.hour) do
      # 相関サブクエリでp1（p2).vegetable_idが一つずつサブクエリに渡される
      subquery = <<~SQL.squish
        SELECT DISTINCT p1.vegetable_id
        FROM prices p1
        INNER JOIN prices p2 ON p1.vegetable_id = p2.vegetable_id
        WHERE p1.date = (
          SELECT MAX(date)
          FROM prices
          WHERE vegetable_id = p1.vegetable_id
        )
        AND p2.date = (
          SELECT MAX(date)
          FROM prices
          WHERE vegetable_id = p2.vegetable_id
          AND date < p1.date
        )
        AND p1.price < p2.price
      SQL
      # サブクエリ結果のvegetable_idを配列で返す
      Price.connection.select_values(subquery)
    end
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
