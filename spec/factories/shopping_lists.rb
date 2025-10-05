FactoryBot.define do
  factory :shopping_list do
    association :user
    sequence(:name) { |n| "買い物リスト#{n}" }
  end
end
