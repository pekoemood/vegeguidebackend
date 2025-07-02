FactoryBot.define do
  factory :season do
    start_month { 10 }
    end_month { 12 }
    note { '冬の時期が旬です' }
    association :vegetable
  end
end
