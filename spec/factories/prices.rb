FactoryBot.define do
  factory :price do
    price { 100 }
    market { '全国' }
    date { Date.today }
    association :vegetable
  end
end
