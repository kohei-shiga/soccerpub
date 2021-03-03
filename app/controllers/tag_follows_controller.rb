class TagFollowsController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in
  
  def create
    @tag = Tag.find(params[:tag_id])
    current_user.tag_follow(@tag)
    count_tag_following_users(@tag)
  end

  def destroy
    @tag = Tag.find(params[:tag_id])
    current_user.tag_unfollow(@tag)
    count_tag_following_users(@tag)
  end
end
