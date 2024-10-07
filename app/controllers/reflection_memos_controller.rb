class ReflectionMemosController < ApplicationController

  def new
    @reflection_memo = ReflectionMemo.new
    @memos = current_user.memos.where(id: params[:memo_ids])
  end

  def new_lastweek
    @reflection_memo = ReflectionMemo.new
    start_date = Date.today.beginning_of_week - 1.week
    end_date = start_date.end_of_week

    @completed_memos = current_user.memos.where(created_at: start_date..end_date, progress: true)
    @inprogress_memos = current_user.memos.where(created_at: start_date..end_date, progress: false)

  end

  def create
    Rails.logger.debug("Received memo_ids: #{params[:memo_ids]}")
    @reflection_memo = current_user.reflection_memos.build(reflection_memo_params)
    @reflection_memo.progress = true
    start_date = Date.today.beginning_of_week - 1.week
    end_date = start_date.end_of_week
    @inprogress_memos = current_user.memos.where(created_at: start_date..end_date, progress: false)
  
    begin
      ref_memo_FB = @reflection_memo.content
      chatgpt_message = ChatgptService.call("あなたはご主人の作成したメモにフィードバックを送る柴犬です。言葉尻はユーモアを交え、ご主人に忠実で論理的、ポジティブなキャラクターとして、ご主人が作成したメモである#{ref_memo_FB} の内容についてフィードバックを125文字以内であげてください。")
      chatgpt_message = "振り返りメモの記載お疲れ様です！" if chatgpt_message.blank?
      @reflection_memo.feedback_given = chatgpt_message
    rescue Net::ReadTimeout
      chatgpt_message = "振り返りメモの記載お疲れ様です！"
      @reflection_memo.feedback_given = chatgpt_message
    end
  
    if @reflection_memo.save
      # メモの紐付けは@reflection_memoが保存された後に行う
      if params[:memo_ids].present?
        memo_ids = params[:memo_ids].map(&:to_i)
        memos = Memo.where(id: memo_ids)
        @reflection_memo.memos = memos
      end
  
      @reflection_memo.FB_to_line(chatgpt_message)
      redirect_to reflection_memos_path, notice: '振り返りメモを作成しました'
    else
      @memos = current_user.memos.where(id: reflection_memo_params[:memo_ids])
      flash.now[:alert] = '振り返りメモの作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @reflection_memos = current_user.reflection_memos
    @q = current_user.reflection_memos.ransack(params[:q])
    @reflection_memos = @q.result.order(created_at: :desc).page(params[:page]).per(3)
    @reflection_memo = @reflection_memos.first
    @chatgpt = @reflection_memo.feedback_given if @reflection_memo
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
  
    if @reflection_memo.update(reflection_memo_params)
      memo_ids = params[:memo_ids].presence&.map(&:to_i) || []
      memos = Memo.where(id: memo_ids)
  
      new_memos = memos - @reflection_memo.memos
      @reflection_memo.memos << new_memos
  
      removed_memos = @reflection_memo.memos - memos
      @reflection_memo.memos.delete(removed_memos)
  
      redirect_to reflection_memo_path, notice: '振り返りメモを更新しました'
    else
      @memos = current_user.memos
      flash[:alert] = @reflection_memo.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @reflection_memo = current_user.reflection_memos.find(params[:id])
    @reflection_memo.reflection_memo_memos.destroy_all
    @reflection_memo.destroy!
    redirect_to reflection_memos_path, notice: '振り返りメモを削除しました'
  end

  private

  def reflection_memo_params
    params.require(:reflection_memo).permit(:content, memo_ids: [])
  end
end
