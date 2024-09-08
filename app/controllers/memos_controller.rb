class MemosController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @memo = @user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params.except(:memo_tags))
    @memo.progress = false
    # memo_tags = params[:memo][:memo_tags].split(',') if params[:memo][:memo_tags]
    # @memo.memo_tags(memo_tags) if memo_tags
    # if @memo.save
    #   redirect_to user_memos_path(current_user) , notice: 'メモを作成しました'
    # else
    #   redirect_to root_path , alert: @memo.errors.full_messages.join(', ')
    # end
  end

  def index
    @user = User.find(params[:user_id])
    @q = current_user.memos.ransack(params[:q] || { progress_eq: false })
    @memos = @q.result.order(created_at: :desc) #.page(params[:page]).per(3)
    @memos = Memo.all
    @memo_tags = current_user.memos.flat_map(&:tags).uniq
  end

  def show
    @user = User.find(params[:user_id])
    @memo = @user.memos.find_by(id: params[:id])
    if @memo
      @memo_tags = @memo.tags.pluck(:name).join(',')
    else
      flash[:alert] = "Memo not found"
      redirect_to user_memos_path(@user)
    end
  end

  def edit
  end

  def update
    @memo = current_user.memos.find(params[:id])
    @memo.assign_attributes(memo_params.except(:memo_tags))
    @memo.progress = params[:memo][:progress].blank? || params[:memo][:progress] == "0" ? false : true
  
    if params[:reflection_memo_ids]
      #一度、すべての紐付けを解除
      @memo.reflection_memos.clear
      # 再度、選択されたメモのみを再度紐付ける
      params[:reflection_memo_ids].reject(&:blank?).each do |reflection_memo_id|
        @memo.reflection_memos << ReflectionMemo.find(reflection_memo_id)
      end
    end
  
    if params[:memo][:memo_tags].is_a?(String)
      @memo.memo_tags = params[:memo][:memo_tags].split(',')
    end
  
    if @memo.update(memo_params)
      redirect_to user_memos_path(current_user), notice: 'メモを更新しました'
    else
      @reflection_memos = current_user.reflection_memos
      flash[:alert] = @memo.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @memo = current_user.memos.find(params[:id])
    @memo.reflection_memos.clear
    @memo.destroy!
    redirect_to user_memos_path(current_user), notice: 'Memo was successfully'
  end

  def tag_search
    if params[:tag].present?
      @memos = Memo.tag_search(params[:tag]).distinct.page(params[:page]).per(5)
    else
      @memos = Memo.all.page(params[:page]).per(5)
    end
    @memo_tags = Tag.all
    @user = current_user
    @q = Memo.ransack(params[:q]) 
    @line_memos = Memo.joins(:tags).where(tags: { name: 'from_LINE' })
    render :index
  end

  def update_tag
    @user = User.find(params[:user_id])
    @memo = @user.memos.find(params[:id])
    tag = Tag.find_or_create_by(name: params[:tag])
  
    # 既存のタグを削除
    @memo.tags.clear
  
    if @memo.tags << tag
      flash[:notice] = 'タグを更新しました'
      redirect_to user_memos_path(@user)
    else
      flash[:alert] = @memo.errors.full_messages
      render :show
    end
  end

  private

  def memo_params
    params.require(:memo).permit(:content, :progress, reflection_memo_ids: [], memo_tags: [])
  end
end
