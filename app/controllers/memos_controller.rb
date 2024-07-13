class MemosController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @memo = @user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params)
    @memo.progress = false
    if @memo.save
      redirect_to user_memos_path(current_user)
    else
      render :new
    end
  end

  def index
    @q = current_user.memos.ransack(params[:q])
    @memos = @q.result.order(created_at: :desc).page(params[:page]).per(5)
  end

  private

  def memo_params
    params.require(:memo).permit(:content)
  end
end
