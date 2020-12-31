class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to root_url
    else
      flash[:danger] = 'ユーザー登録に失敗しました。'
      redirect_to :new
    end
  end

  def edit
  end

  def update
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
