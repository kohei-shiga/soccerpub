class Admin::UsersController < ApplicationController
  before_action :admin_user
  
  def index
    @users = User.all.page(params[:page])
  end
  
  def spams
    spams = ReportSpam.all
    spam_articles = ReportSpam.spam_articles(spams)
    @spam_articles = Kaminari.paginate_array(spam_articles).page(params[:page])
  end
  
  def destroy_spam_article
    article = Article.find(params[:id])
    article.destroy
    redirect_to spams_admin_users_url
  end
  
  private
  
  def admin_user
    if !current_user.admin?
      redirect_to root_url
    end
  end
end
