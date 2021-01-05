class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :edit, :update, :followings, :followers]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles
    counts(@user)
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to root_url
    else
      flash[:danger] = 'ユーザー登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザーを更新しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザー更新に失敗しました。'
      render :edit
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
    counts(@user)
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :introduction)
  end
end
