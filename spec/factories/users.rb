FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test#{n}"}
    sequence(:email) { |n| "user#{n}@example.com"}
    password { 'password' }
  end

  factory :google_user, class: 'User' do
    name { "Googleユーザー"}
    email { 'test@gmail.com'}
    google_uid { SecureRandom.hex(10) }
    password { 'dummy' }
    
  end
end