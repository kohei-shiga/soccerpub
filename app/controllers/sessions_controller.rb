class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    
    if login(email, password)
      flash[:success] = 'ログインしました。'
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to root_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
  private
  
  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      if @user.activated?
        log_in(@user)
        return true
      else
        message = "アカウントが有効化されていません。"
        message += "アカウント有効化用のメールをご確認ください。"
        flash.now[:warning] = message
        return false
      end
    else
      return false
    end
  end
end
