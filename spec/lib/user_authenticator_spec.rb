require 'rails_helper'


describe UserAuthenticator do
  describe '#perform' do
    let(:authenticator) { described_class.new('sample_code') }
    subject{ authenticator.perform }

    context 'when code is correct' do
      let(:user_data) do
        {
          login: 'pperez',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avatar',
          name: 'Pedro Perez'
        }
      end
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('validaccesstoken')
        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end

      it 'should save the user if it does not exist' do
        expect { subject }.to change { User.count }.by(1)
        expect(authenticator.user.name).to eq('Pedro Perez')
      end

      it 'should reuse registered user' do
        existing_user = create(:user, user_data)
        expect { subject }.not_to change { User.count }
        expect(authenticator.user).to eq(existing_user)
      end

      it "should create and set user's access token" do
        expect { subject }.to change { AccessToken.count }.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
