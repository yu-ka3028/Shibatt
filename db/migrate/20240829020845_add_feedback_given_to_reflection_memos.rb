class AddFeedbackGivenToReflectionMemos < ActiveRecord::Migration[6.0]
  def change
    add_column :reflection_memos, :feedback_given, :string, default: ""
  end
end