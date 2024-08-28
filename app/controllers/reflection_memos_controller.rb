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
    ref_memo_FB = @reflection_memo.content
		    begin
    # プロンプトに日付を代入し、今日の誕生日の有名人を紹介させる
      @chatgpt = ChatgptService.call("あなたはご主人の作成したメモにフィードバックを送る柴犬です。言葉尻はユーモアを交え、ご主人に忠実で論理的、ポジティブなキャラクターとして、ご主人が作成したメモである#{ref_memo_FB} の内容についてフィードバックをあげてください。")
	    # タイムアウトエラーが起きたときの処理。この場合は無難なAPIを使わず無難な内容にする
		    rescue Net::ReadTimeout
      @chatgpt = "振り返りメモの記載お疲れ様です！"
    end
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
