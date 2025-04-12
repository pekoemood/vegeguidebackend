class Vegetable < ApplicationRecord
  has_many :prices, dependent: :destroy
end
