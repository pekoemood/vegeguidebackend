FactoryBot.define do
  factory :recipe do
    sequence(:name) { |n| "レシピ#{n}" }
    instructions { 'テストレシピです' }
    cooking_time { 5 }
    servings { 2 }
    recipe_category { '主菜' }
    calorie { 500 }
    cooking_method { 'フライパン' }
    purpose { 'ダイエット' }
    association :user
  end
end
