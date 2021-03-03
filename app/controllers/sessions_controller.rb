class SessionsController < ApplicationController
  def new; end
  
  def omniauth
    user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.name = auth['info']['name']
      u.email = auth['info']['email']
      u.auth_image = auth['info']['image']
      u.password = SecureRandom.hex(16)
    end
    if user.valid?
      user.activate unless user.activated?
      log_in(user)
      flash[:success] = 'ログインしました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
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
    return unless @user&.authenticate(password)

    if @user.activated?
      log_in(@user)
      true
    else
      message = "アカウントが有効化されていません。"
      message += "アカウント有効化用のメールをご確認ください。"
      flash.now[:warning] = message
      false
    end
    
  end
  
  def auth
    request.env['omniauth.auth']
  end
end
