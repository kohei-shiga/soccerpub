class Admin::UsersController < ApplicationController
  before_action :admin_user
  def index
    @users = User.all.page(params[:page])
  end
  
  private
  
  def admin_user
    if !current_user.admin?
      redirect_to root_url
    end
  end
end
