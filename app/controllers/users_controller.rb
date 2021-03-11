class UsersController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in, only: %i[edit update destroy followings followers favorite_articles introduction]
  before_action :set_user, only: %i[show edit update destroy followings followers favorite_articles introduction]
  before_action :correct_user, only: %i[edit update destroy]
  
  def new
    @user = User.new
  end

  def show
    @articles = @user.articles.page(params[:page]).preload(:attached_tags)
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
    counts(@user)
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザーを更新しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザー更新に失敗しました。'
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to root_path
  end
  
  def followings
    @followings = @user.followings.page(params[:page]).eager_load(image_attachment: :blob)
    counts(@user)
  end
  
  def followers
    @followers = @user.followers.page(params[:page]).eager_load(image_attachment: :blob)
    counts(@user)
  end
  
  def favorite_articles
    @articles = @user.favorite_articles.page(params[:page]).order(created_at: :desc).preload(:attached_tags, user: { image_attachment: :blob })
    counts(@user)
  end

  def introduction
    @articles = @user.favorite_articles.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :friendly_id, :image, :email, :password, :password_confirmation, :introduction)
  end

  def set_user
    if params[:friendly_id].chr == '@'
      params[:friendly_id].slice!(0)
      @user = User.find_by(friendly_id: params[:friendly_id])
    else
      @user = User.find(params[:friendly_id])
    end
  end

  def correct_user
    return if current_user == @user

    redirect_to root_url
  end
      
end
