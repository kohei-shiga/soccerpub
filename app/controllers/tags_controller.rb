class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.tagged_articles.page(params[:page]).order(updated_at: :desc)
    count_tagged_articles(@tag)
    count_tag_following_users(@tag)
  end
end
