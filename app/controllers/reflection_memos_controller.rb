class ReflectionMemosController < ApplicationController

  def new
    @reflection_memo = ReflectionMemo.new
    @memos = current_user.memos.where(id: params[:memo_ids])
  end 

  def create
    @reflection_memo = current_user.reflection_memos.build(reflection_memo_params)
    @reflection_memo.progress = true
    if @reflection_memo.save
      ref_memo_FB = @reflection_memo.content
      # begin
      #   @chatgpt = ChatgptService.call("あなたはご主人の作成したメモにフィードバックを送る柴犬です。言葉尻はユーモアを交え、ご主人に忠実で論理的、ポジティブなキャラクターとして、ご主人が作成したメモである#{ref_memo_FB} の内容についてフィードバックをあげてください。")
      #   @reflection_memo.update(feedback_given: @chatgpt)
      #   @reflection_memo.FB_to_line(@chatgpt)
      # rescue Net::ReadTimeout
      #   @chatgpt = "振り返りメモの記載お疲れ様です！"
      # end
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
    @reflection_memo = @reflection_memos.first # 最新のメモを取得
    @chatgpt = @reflection_memo.feedback_given if @reflection_memo # メモが存在する場合のみ@chatgptを設定
  end

  def show
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    @memos = current_user.memos
    @ref_memo = ReflectionMemo.find(params[:id])
  end

  def edit
  end

  def update
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    # 一度、すべての紐付けを解除
    @reflection_memo.memos.clear
    # 再度、選択されたメモのみを再度紐付ける
    if params[:memo_ids]
      params[:memo_ids].each do |memo_id|
        @reflection_memo.memos << Memo.find(memo_id)
      end
    end
  
    if @reflection_memo.update(reflection_memo_params)
      redirect_to reflection_memo_path(@reflection_memo), notice: 'Reflection memo was successfully updated.'
    else
      @memos = current_user.memos
      flash[:alert] = @reflection_memo.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    @reflection_memo.memos.clear
    @reflection_memo.destroy
    redirect_to reflection_memos_path, notice: 'Reflection memo was successfully destroyed.'
  end

  private

  def reflection_memo_params
    params.require(:reflection_memo).permit(:content, :progress, memo_ids: [])
  end
end
