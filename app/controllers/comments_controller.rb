class CommentsController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in
  before_action :set_article

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to article_url(@article)
    else
      render 'articles/show'
    end
  end
  
  private

  def comment_params
    params.require(:comment).permit(:comment_content, :article_id)
  end

  def set_article
    @article = Article.find(params[:article_id])
    @user = @article.user
    @count_favorites = @article.liked_users.count
    @comment = Comment.new
    @comments = @article.comments
  end
end