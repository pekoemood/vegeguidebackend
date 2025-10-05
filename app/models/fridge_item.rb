class FridgeItem < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :category, presence: true

  def expire_status
    return "unset" if expire_date.nil?

    today = Time.zone.today
    limit_day = (expire_date - today).to_i
    case
    when limit_day < 0
      "expired"
    when limit_day <= 2
      "urgent"
    when limit_day <= 5
      "warning"
    else
      "safe"
    end
  end
end
