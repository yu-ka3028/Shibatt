class Memo < ApplicationRecord
  paginates_per 5
  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress", "user_id"]
  end
end
