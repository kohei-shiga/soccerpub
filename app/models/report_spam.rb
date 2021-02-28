class ReportSpam < ApplicationRecord
  belongs_to :user
  belongs_to :article
  
  validates :user_id, presence: true
  validates :article_id, presence: true
  
  def self.spam_articles(spams)
    spam_articles = []
    spams.each do |spam|
      spam_article = Article.find(spam.article_id)
      spam_articles << spam_article
    end
    spam_articles
  end
end
