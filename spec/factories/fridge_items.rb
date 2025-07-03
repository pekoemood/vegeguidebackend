FactoryBot.define do
  factory :fridge_item do
    name { '大根' }
    amount { 150.0 }
    unit { 'g' }
    category { '野菜' }
    expire_date { Date.today }
    display_amount { '150g' }
    association :user
  end
end
