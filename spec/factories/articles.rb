FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "my article title#{n}" }
    content { "article content" }
    association :user
  end
end