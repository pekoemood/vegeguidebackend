FactoryBot.define do
  factory :ingredient do
    name { 'かぶ' }
    amount { 1 }
    unit { '個' }
    display_amount { '1個' }
    association :recipe
  end
end
