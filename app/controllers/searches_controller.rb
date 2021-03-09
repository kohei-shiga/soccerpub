class SearchesController < ApplicationController
  
  def index
    @search = params[:search]
    @articles = Article.search(@search).page(params[:page]).order(created_at: :desc).preload(:attached_tags, user: {image_attachment: :blob})
    @user = User.new
    @count_search_result = @articles.count
    render 'articles/index'
  end
end
