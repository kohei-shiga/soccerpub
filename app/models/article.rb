class Article < ApplicationRecord
  belongs_to :user
  
  has_many :reverses_of_favorite, class_name: 'Favorite'
  has_many :liked_users, through: :reverses_of_favorite, source: :user

  validates :content, presence: true, length: { maximum: 1000 }
end
