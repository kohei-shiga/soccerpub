class SearchesController < ApplicationController
  
  def index
    @articles = Article.search(params[:search]).order(created_at: :desc)
    @search = params[:search]
    @count_search_result = @articles.count
    render 'articles/index'
  end
end
