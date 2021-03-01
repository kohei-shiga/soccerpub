class CommentsController < ApplicationController
  before_action :set_article

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
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
    @comments = @article.comments
  end
end