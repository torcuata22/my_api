require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#validations' do
    it 'should have valid factory' do
      access_token = FactoryBot.build(:access_token)
      expect(access_token).to be_valid
    end

    it 'should validate token' do
      access_token = FactoryBot.build(:access_token, token: nil)
      expect(access_token).not_to be_valid
      expect(access_token.errors[:token]).to include("can't be blank")
    end
  end

  describe '#new' do
    it 'should have a token present after initialize' do
      expect(AccessToken.new.token).to be_present
    end

    it 'should generate uniq token' do
      user = create :user
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      new_access_token = user.build_access_token
      expect(new_access_token).to be_valid
      expect(new_access_token.token).to be_present
    end
  end
end
