FactoryBot.define do
  factory :recipe_step do
    sequence(:step_number) { |n| "ステップ#{n}" }
    sequence(:description) { |n| "調理方法#{n}" }
    created_at { Date.today }
    updated_at { Date.today }
    association :recipe
  end
end
