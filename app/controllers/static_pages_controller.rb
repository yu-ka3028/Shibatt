class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [:terms_of_service, :privacy_policy, :contact_form, :top]
  def top 
    @user = current_user
    Rails.logger.info "Username: #{@user.username}" if @user
    @memo = @user.memos.build if @user
    @memo_tags = @user.memos.eager_load(:tags).flat_map(&:tags).uniq if @user
    @progress_rate = @user&.progress_rate || { in_progress: 0, completed: 0 }
  end

  def privacy_policy
  end

  def terms_of_service
  end

  def contact_form
  end
end
