class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  def top 
    @user = current_user
    Rails.logger.info "Username: #{@user.username}" if @user
    @memo = @user.memos.build if @user
    @memo_tags = @user.memos.eager_load(:tags).flat_map(&:tags).uniq if @user
    @progress_rate = @user&.progress_rate || { in_progress: 0, completed: 0 }
  end
end
