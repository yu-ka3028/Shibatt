class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  def top 
    @user = current_user
    @memo = @user.memos.build if @user
    @progress_rate = @user.progress_rate if @user
  end
end
