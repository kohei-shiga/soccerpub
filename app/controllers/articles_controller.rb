class ArticlesController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in, only: %i[new create destroy timeline favorite_articles tagged_articles]
  before_action :correct_user, only: %i[destroy]
  
  def index
    @user = User.new
    @articles = Article.page(params[:page]).order(created_at: :desc).preload(:attached_tags, user: { image_attachment: :blob })
  end
  
  def show
    @article = Article.find(params[:id])
    @user = @article.user
    @count_favorites = @article.liked_users.count
    @comments = @article.comments
    @comment = Comment.new
  end

  def new
    @form = ArticleForm.new
  end

  def create
    @form = ArticleForm.new(article_params)
    if @form.save
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
    @articles = Article.feed(current_user).page(params[:page]).order(created_at: :desc).preload(:attached_tags, user: { image_attachment: :blob })
  end
  
  def favorite_articles
    @articles = current_user.favorite_articles.page(params[:page]).order(created_at: :desc).preload(:attached_tags, user: { image_attachment: :blob })
  end
  
  def tagged_articles
    articles = current_user.following_tags.preload(tagged_articles: [:attached_tags, user: { image_attachment: :blob }]).map { |o| o.tagged_articles.to_ary }.flatten.uniq.sort.reverse
    @articles = Kaminari.paginate_array(articles).page(params[:page])
  end

  def monthly_ranking
    monthly_articles = Article.where(updated_at: Time.zone.today.all_month).preload(:attached_tags, user: { image_attachment: :blob })
    @monthly_ranking_articles = Article.ranking(monthly_articles)
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title, :content, :tag_names).merge(user_id: current_user.id)
  end
  
  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    return if @article

    redirect_to root_url
  end
end
