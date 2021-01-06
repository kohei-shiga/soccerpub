class FavoritesController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    current_user.favorite(@article)
    flash[:success] = '記事をお気に入りしました。'
    redirect_to @article
  end

  def destroy
    @article = Article.find(params[:article_id])
    current_user.unfavorite(@article)
    flash[:success] = '記事のお気に入りを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end
