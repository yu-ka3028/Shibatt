class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  def top 
    @user = current_user
    @memo = @user.memos.build if @user
  end
end
