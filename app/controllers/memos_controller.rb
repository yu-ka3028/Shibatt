class MemosController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @memo = @user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params.except(:memo_tags))
    @memo.progress = false
    memo_tags = params[:memo][:memo_tags].split(',') if params[:memo][:memo_tags]
    @memo.memo_tags(memo_tags) if memo_tags
    if @memo.save
      redirect_to user_memos_path(current_user)
    else
      render "static_pages/top"
    end
  end

  def index
    @user = User.find(params[:user_id])
    @q = current_user.memos.ransack(params[:q])
    @memos = @q.result.order(created_at: :desc).page(params[:page]).per(5)
    @memo_tags = Tag.all
  end

  def show
    @user = User.find(params[:user_id])
    @memo = Memo.find(params[:id])
    @memo_tags = @memo.memo_tags
  end

  def edit
    @user = User.find(params[:user_id])
    @memo = @user.memos.find(params[:id])
    @memo_tags = @memo.tags.pluck(:name).join(',')
  end

  def update
    @memo = current_user.memos.find(params[:id])
    @memo.assign_attributes(memo_params.except(:memo_tags))
    @memo.progress = false if params[:memo][:progress] == "0"
    if params[:memo][:memo_tags]
      @memo.memo_tags = params[:memo][:memo_tags].split(',')
    end
    if @memo.save
      redirect_to user_memos_path(current_user), notice: 'メモを更新しました'
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

  def tag_search
    if params[:tag].present?
      @memos = Memo.tag_search(params[:tag]).distinct.page(params[:page]).per(5)
    else
      @memos = Memo.all.page(params[:page]).per(5)
    end
    @memo_tags = Tag.all
    @user = current_user
    @q = Memo.ransack(params[:q])  # Ransack::Searchオブジェクトを作成
    render :index
  end

  private

  def memo_params
    params.require(:memo).permit(:content, :progress)
  end
end
