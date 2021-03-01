class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :comment_content, length: { maximum: 200 }, profanity_filter: true
end
