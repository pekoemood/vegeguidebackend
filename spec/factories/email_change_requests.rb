FactoryBot.define do
  factory :email_change_request do
    new_email { 'new@example.com' }
    token { 'test' }
    expires_at { Date.tomorrow }
    association :user
  end
end
