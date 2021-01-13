class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    has_secure_password
    has_one_attached :image
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
    validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                      massage: "適切な画像フォーマットでなければなりません" },
                      size: { less_than: 5.megabytes,
                              message: "5MGよりも小さいサイズでなければなりません" }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX, allow_blank: true }, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8, maximum: 20 }, allow_nil: true 
    
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
    
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def self.new_token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    def display_image
        image.variant(resize_to_limit: [200,200])
    end
    
    def index_display_image
        image.variant(resize_to_limit: [30,30])
    end
    
    def navbar_display_image
        image.variant(resize_to_limit: [50,50])
    end
    
    private
    
        def downcase_email
            self.email = email.downcase
        end
        
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
