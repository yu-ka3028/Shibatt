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
    @user = User.find(params[:user_id])
    @q = current_user.memos.ransack(params[:q])
    @memos = @q.result.order(created_at: :desc).page(params[:page]).per(5)
    @memo = @memos.first
  end

  def show
    @user = User.find(params[:user_id])
    @memo = Memo.find(params[:id])
  end

  def edit
    @user = User.find(params[:user_id])
    @memo = @user.memos.find(params[:id])
  end

  def update
    @memo = Memo.find(params[:id])
    if @memo.update(memo_params)
      redirect_to user_memos_path(current_user)
    else
      render :edit
    end
  end
  
  def destroy
    @memo = Memo.find(params[:id])
    if @memo.reflections.any?
      redirect_to edit_user_memo_path(@user, @memo)
    else
      @memo.destroy
      redirect_to user_memos_path(@user), notice: 'Memo was successfully deleted.'
    end
  end

  private

  def memo_params
    params.require(:memo).permit(:content)
  end
end
