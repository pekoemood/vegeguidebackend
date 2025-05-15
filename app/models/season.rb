class Season < ApplicationRecord
  belongs_to :vegetable

  validates :start_month, :end_month, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 13 }

  scope :in_season, -> {
    today_month = Date.today.month
    where("start_month <= ? AND ? <= end_month OR start_month > end_month AND (? <= end_month OR ? >= start_month)",
    today_month, today_month, today_month, today_month)
  }


  def in_season?
    current_month = Date.today.month
    if self.start_month <= self.end_month
      start_month <= current_month && current_month <= end_month
    else
      current_month >= start_month || current_month <= end_month
    end
  end
end
