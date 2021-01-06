class ArticlesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :destroy, :timeline]
  before_action :correct_user, only: [:destroy]
  
  def index
    @articles = Article.all.order(created_at: :desc)
  end
  
  def show
    @article = Article.find(params[:id])
    @user = @article.user
    @count_favorites = @article.liked_users.count
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = '記事を投稿しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render :new
    end
  end

  def destroy
    @article.destroy
    flash[:success] = '記事を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def timeline
    @articles = Article.where(user_id: current_user.following_ids + [current_user.id])
  end
  
  def favorite_articles
    @articles = current_user.favorite_articles
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title, :content)
  end
  
  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    unless @article
      redirect_to root_url
    end
  end
end