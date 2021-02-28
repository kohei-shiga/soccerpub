class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]
  
  def new; end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定用のメールを送りました。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりませんでした。"
      render :new
    end
  end

  def edit; end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードの再設定を完了しました。"
      redirect_to root_url
    else
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def set_user
    @user = User.find_by(email: params[:email])
  end
  
  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end
  
  def check_expiration
    return if @user.password_reset_expired? == false

    flash[:danger] = "パスワードの再設定の有効期限が切れました。"
    redirect_to new_password_reset_url
  end
end
