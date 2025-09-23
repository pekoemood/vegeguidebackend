FactoryBot.define do
  factory :vegetable do
    sequence(:name) { |n| "テスト野菜#{n}" }
    description { 'おいしい野菜です' }
    origin { '全国各地' }
    storage { '冷蔵庫で保存' }
    image_url {  "https://example.com/vegetable.jpg" }

    trait :daikon do
      name { "だいこん" }
      description { "日本の代表的な根菜" }
      origin { "北海道" }
      storage { "冷蔵庫で保存、乾燥させないように" }
    end

    trait :carrot do
      name { "人参" }
    end

    trait :cabbage do
      name { "キャベツ" }
    end

    trait :with_season do
      after(:create) do |vegetable|
        create(:season, vegetable: vegetable, start_month: 11, end_month: 2, note: '冬が最盛期')
      end
    end
  end
end
