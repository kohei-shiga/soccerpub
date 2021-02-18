class Article < ApplicationRecord
  has_rich_text :content
  belongs_to :user

  has_many :reverses_of_favorite, class_name: 'Favorite', dependent: :destroy
  has_many :liked_users, through: :reverses_of_favorite, source: :user
  
  has_many :reverses_of_report_spam, class_name: 'ReportSpam', dependent: :destroy
  has_many :reported_users, through: :reverses_of_report_spam, source: :user
  
  has_many :reverses_of_tag_maps, class_name: 'TagMap', dependent: :destroy
  has_many :attached_tags, through: :reverses_of_tag_maps, source: :tag

  def save_articles(savearticle_tags)
    current_tags = self.attached_tags.pluck(:name) unless self.attached_tags.nil?
    old_tags = current_tags - savearticle_tags
    new_tags = savearticle_tags - current_tags
    
    old_tags.each do |old_name|
      self.attached_tags.delete(Tag.find_by(name: old_name))
    end
    
    new_tags.each do |new_name|
      article_tag = Tag.find_or_create_by(name: new_name)
      self.attached_tags << article_tag
    end
  end
  
  def self.search(search)
    if search
      Article.where(['title LIKE ?', "%#{search}%"])
    else
      return Article.all
    end
  end
end
