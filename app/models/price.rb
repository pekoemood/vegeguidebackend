class Price < ApplicationRecord
  belongs_to :vegetable

  def self.monthly_average_for(vegetable_id)
    where(vegetable_id: vegetable_id)
    .group("DATE_TRUNC('month', date)")
    .select("DATE_TRUNC('month', date) AS month, AVG(price) AS average_price")
    .order("month")
  end
end
