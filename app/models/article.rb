class Article < ApplicationRecord
  has_rich_text :content
  belongs_to :user

  has_many :reverses_of_favorite, class_name: 'Favorite', dependent: :destroy
  has_many :liked_users, through: :reverses_of_favorite, source: :user
  
  has_many :reverses_of_report_spam, class_name: 'ReportSpam', dependent: :destroy
  has_many :reported_users, through: :reverses_of_report_spam, source: :user
  
  has_many :reverses_of_tag_maps, class_name: 'TagMap', dependent: :destroy
  has_many :attached_tags, through: :reverses_of_tag_maps, source: :tag

  has_many :comments, dependent: :destroy
  
  scope :search, ->(search) { where(['title LIKE ?', "%#{search}%"]) if search.present? }
  scope :feed, ->(user) { where("user_id IN (?) OR user_id = ?", user.following_ids, user.id) }
  
end
