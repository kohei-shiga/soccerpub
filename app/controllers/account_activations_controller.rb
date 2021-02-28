class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントが有効化されました。"
    else
      flash[:danger] = "適切な有効化リンクではありません"
    end
    redirect_to root_url
  end
end
