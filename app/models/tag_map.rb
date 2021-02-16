class TagMap < ApplicationRecord
  belongs_to :tag
  belongs_to :article
  
  validates :tag_id, presence: true
  validates :article_id, presence: true
end
