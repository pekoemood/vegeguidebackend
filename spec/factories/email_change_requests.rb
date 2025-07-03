FactoryBot.define do
  factory :email_change_request do
    new_email { 'new@example.com' }
    token { 'test' }
    expires_at { Date.today }
    association :user
  end
end
