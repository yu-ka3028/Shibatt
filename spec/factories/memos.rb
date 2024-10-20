FactoryBot.define do
  factory :memo do
    content { "Test content" }
    user
  end
end