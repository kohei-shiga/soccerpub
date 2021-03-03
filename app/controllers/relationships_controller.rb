class RelationshipsController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in
  
  def create
    @user = User.find(params[:follow_id])
    current_user.follow(@user)
    counts(@user)
  end

  def destroy
    @user = User.find(params[:follow_id])
    current_user.unfollow(@user)
    counts(@user)
  end
end
