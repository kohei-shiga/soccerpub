class TagFollowsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @tag = Tag.find(params[:tag_id])
    current_user.tag_follow(@tag)
    redirect_to @tag
  end

  def destroy
    @tag = Tag.find(params[:tag_id])
    current_user.tag_unfollow(@tag)
    redirect_to @tag
  end
end
