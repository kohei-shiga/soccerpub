class ArticlesController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in, only: %i[new create destroy timeline favorite_articles tagged_articles]
  before_action :correct_user, only: %i[destroy]
  
  def index
    @user = User.new
    @articles = Article.page(params[:page]).order(created_at: :desc)
  end
  
  def show
    @article = Article.find(params[:id])
    @user = @article.user
    @count_favorites = @article.liked_users.count
    @comments = @article.comments
    @comment = Comment.new
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      tag_list = params[:tag_name].split(',')
      tag_list.map!(&:strip)
      @article.save_articles(tag_list)
      flash[:success] = '記事を投稿しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '記事の投稿に失敗しました。'
      render :new
    end
  end

  def destroy
    @article.destroy
    flash[:success] = '記事を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def timeline
    @articles = current_user.feed.page(params[:page])
  end
  
  def favorite_articles
    @articles = current_user.favorite_articles.page(params[:page])
  end
  
  def tagged_articles
    articles = current_user.following_tags.map { |o| o.tagged_articles.to_ary }.flatten.uniq
    @articles = Kaminari.paginate_array(articles).page(params[:page])
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title, :content)
  end
  
  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    return if @article

    redirect_to root_url
  end
end
