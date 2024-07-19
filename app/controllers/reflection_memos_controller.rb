class ReflectionMemosController < ApplicationController
  def new
    # pp params[:memo_ids]
    @reflection_memo = ReflectionMemo.new
    # @memos = Memo.where(id: params[:memo_ids])
    @memos = current_user.memos.where(id: params[:memo_ids])
  end 

  def create
    @reflection_memo = current_user.reflection_memos.build(reflection_memo_params)
    # @reflection_memo = current_user.reflection_memos.new(reflection_memo_params)
    # pp @reflection_memo.memos
    @reflection_memo.progress = true
=begin    
    memo_ids = reflection_memo_params[:memo_ids]
    if memo_ids
      memo_ids.each do |memo_id|
        memo = Memo.find(memo_id)
        @reflection_memo.memos << memo
      end
    end
=end
    if @reflection_memo.save
      redirect_to reflection_memos_path, notice: 'Reflection memo was successfully created.'
    else
      # @memos = Memo.where(id: memo_ids)
      @memos = current_user.memos.where(id: reflection_memo_params[:memo_ids])
      redirect_to new_reflection_memo_path, alert: 'Failed to create reflection memo.'
    end
  end

  def index
    @reflection_memos = current_user.reflection_memos
    @q = current_user.reflection_memos.ransack(params[:q])
    @reflection_memos = @q.result.order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    @memos = current_user.memos
  end

  def update
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    if @reflection_memo.update(reflection_memo_params)
      redirect_to reflection_memos_path, notice: 'Reflection memo was successfully updated.'
    else
      @memos = current_user.memos
      render :edit
    end
  end

  private

  def reflection_memo_params
    params.require(:reflection_memo).permit(:content, memo_ids: [])
  end
end
