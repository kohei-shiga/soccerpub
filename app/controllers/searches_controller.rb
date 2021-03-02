class SearchesController < ApplicationController
  
  def index
    @articles = Article.search(params[:search]).page(params[:page]).order(created_at: :desc)
    @search = params[:search]
    @user = User.new
    @count_search_result = @articles.count
    render 'articles/index'
  end
end
