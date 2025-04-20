class Season < ApplicationRecord
  belongs_to :vegetable

  validates :start_month, :end_month, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 13 }
end
