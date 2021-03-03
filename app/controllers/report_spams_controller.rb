class ReportSpamsController < ApplicationController
  include CommonActions
  before_action :require_user_logged_in
  
  def create
    @article = Article.find(params[:article_id])
    current_user.report_spam(@article)
    redirect_to @article
  end
end
