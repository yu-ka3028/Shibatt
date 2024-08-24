class ReflectionMemosController < ApplicationController
  def new
    @reflection_memo = ReflectionMemo.new
    @memos = current_user.memos.where(id: params[:memo_ids])
  end 

  def create
    @reflection_memo = current_user.reflection_memos.build(reflection_memo_params)
    @reflection_memo.progress = true

    if @reflection_memo.save
      redirect_to reflection_memos_path, notice: 'Reflection memo was successfully created.'
    else
      @memos = current_user.memos.where(id: reflection_memo_params[:memo_ids])
      flash.now[:alert] = 'Failed to create reflection memo.'
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @reflection_memos = current_user.reflection_memos
    @q = current_user.reflection_memos.ransack(params[:q])
    @reflection_memos = @q.result.order(created_at: :desc).page(params[:page]).per(3)
  end

  def edit
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    @memos = current_user.memos
  end

  def update
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    if @reflection_memo.update(reflection_memo_params)
      pp reflection_memo_params
      redirect_to reflection_memos_path, notice: 'Reflection memo was successfully updated.'
    else
      @memos = current_user.memos
      flash[:alert] = @reflection_memo.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reflection_memo_params
    params.require(:reflection_memo).permit(:content, :progress, memo_ids: [])
  end
end
