FactoryBot.define do
  factory :article do
    title { "my article title" }
    association :user
  end
end