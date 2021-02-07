FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test_User#{n}"}
    sequence(:email) { |n| "Test#{n}@example.com"}
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
    
    trait :no_activated do
      activated { false }
      activated_at { nil }
    end
    
    trait :with_articles do
      after(:create) { |user| create_list(:article, 5, user: user)}
    end
  end
end
