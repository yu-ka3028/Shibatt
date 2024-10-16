class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def create
    @user = login(params[:username], params[:password])

    if @user
      redirect_back_or_to root_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました"
  end
end
