class TagsController < ApplicationController
  include CommonActions
  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.tagged_articles.page(params[:page]).order(updated_at: :desc).includes(:attached_tags, user: {image_attachment: :blob})
    count_tagged_articles(@tag)
    count_tag_following_users(@tag)
  end
end
