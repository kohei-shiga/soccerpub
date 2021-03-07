class Admin::UsersController < ApplicationController
  include CommonActions
  before_action :admin_user
  
  def index
    @users = User.all.page(params[:page]).eager_load(image_attachment: :blob)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
  
end
