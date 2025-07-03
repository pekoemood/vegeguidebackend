FactoryBot.define do
  factory :shopping_list_item do
    checked { false }
    association :recipe
    association :ingredient
    association :shopping_list
  end
end
