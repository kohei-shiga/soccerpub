class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @article = Article.find(params[:article_id])
    current_user.favorite(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    current_user.unfavorite(@article)
  end
end
