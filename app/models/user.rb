class User < ApplicationRecord
    before_save { self.email.downcase! }
    has_secure_password
    has_many :articles
    
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    has_many :favorites
    has_many :favorite_articles, through: :favorites, source: :article
    
    has_many :tag_follows
    has_many :following_tags, through: :tag_follows, source: :tag
    
    validates :name, presence: true, length: { maximum: 20 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    
    # follow機能
    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end
    
    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end
    
    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    # favorite機能
    def favorite(article)
        self.favorites.find_or_create_by(article_id: article.id)
    end
    
    def unfavorite(article)
        favorite = self.favorites.find_by(article_id: article.id)
        favorite.destroy if favorite
    end
    
    def favorite?(article)
        self.favorite_articles.include?(article)
    end
    
    #tag_follow機能
    def tag_follow(tag)
        self.tag_follows.find_or_create_by(tag_id: tag.id)
    end
  
    def tag_unfollow(tag)
        tag_follow = self.tag_follows.find_by(tag_id: tag.id)
        tag_follow.destroy if tag_follow
    end
    
    def tag_following?(tag)
        self.following_tags.include?(tag)
    end
    
    
end
