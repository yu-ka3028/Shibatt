# spec/models/memo_spec.rb
require 'rails_helper'

RSpec.describe Memo, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:memo) { FactoryBot.build(:memo, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(memo).to be_valid
    end

    it 'is not valid without content' do
      memo.content = nil
      expect(memo).not_to be_valid
    end

    it 'is not valid with content over 255 characters' do
      memo.content = 'a' * 256
      expect(memo).not_to be_valid
    end
  end
end