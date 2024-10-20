# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is not valid without a username" do
    user = FactoryBot.build(:user, username: nil)
    expect(user).to_not be_valid
  end

end