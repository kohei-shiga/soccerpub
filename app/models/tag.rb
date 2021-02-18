class Tag < ApplicationRecord
  has_many :reverses_of_tag_follows, class_name: 'TagFollow', dependent: :destroy
  has_many :tag_following_users, through: :reverses_of_tag_follows, source: :user
  
  has_many :tag_maps, dependent: :destroy
  has_many :tagged_articles, through: :tag_maps, source: :article
  
end
