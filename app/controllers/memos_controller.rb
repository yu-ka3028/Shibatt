class MemosController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @memo = @user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params)
    @memo.save
    redirect_to user_memos_path(current_user)
  end

  def index
    @memos = current_user.memos.order(created_at: :desc)
  end

  private

  def memo_params
    params.require(:memo).permit(:content)
  end
end
