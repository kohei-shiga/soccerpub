FactoryBot.define do
  factory :comment do
    comment_content { "MyString" }
    user { nil }
    article { nil }
  end
end
