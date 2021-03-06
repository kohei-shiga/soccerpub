module CommonActions
  extend ActiveSupport::Concern

  def require_user_logged_in
    return if logged_in?
    
    redirect_to login_url
  end

  def admin_user
    return if current_user.admin?
    
    redirect_to root_url
  end
  
  def counts(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
  
  def count_tagged_articles(tag)
    @count_tagged_articles = tag.tagged_articles.count
  end
  
  def count_tag_following_users(tag)
    @count_tag_following_users = tag.tag_following_users.count
  end
end