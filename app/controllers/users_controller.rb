class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:edit, :update, :followings, :followers, :favorite_articles]
  
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page])
    counts(@user)
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      @user.send_activation_email
      flash[:info] = 'アカウントを有効化するため、メールをご確認ください。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました。'
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
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorite_articles
    @user = User.find(params[:id])
    @articles = @user.favorite_articles.page(params[:page])
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :image, :email, :password, :password_confirmation, :introduction)
  end
end
