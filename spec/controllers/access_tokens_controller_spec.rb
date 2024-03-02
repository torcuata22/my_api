require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe '#create' do
    shared_examples_for "unauthorized_requests" do
      let(:error) do
        {
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title" => "Authentication code is invalid",
          "detail" => "You must provide a valid code to exchange for a token"
        }
      end
      it 'should return 401 status code' do
        # these were replaced post :create, :invalidcode
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        # these were replaced post :create
        subject
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to include(error)
      end

    end
    context 'when no code provided' do
      subject { post :create }
      it_behaves_like "unauthorized_requests"
    end

    context 'when invalid code provided' do
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(github_error)
      end

      subject { post :create, params: { code: 'invalid_code' } }
      it_behaves_like "unauthorized_requests"
    end

    context 'when success request' do
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
      subject { post :create, params: { code: 'valid_code' } }
      it 'should return a 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should return proper json body' do
        expect { subject }.to change{ User.count }.by(1)
        user = User.find_by(login: 'pperez')
        puts user
        puts "This is the access token: #{user.access_token}"
        puts "Response body: #{response.body}"


        expect(JSON.parse(response.body)['token']).to eq(user.access_token.token)

        # expect(JSON.parse(response.body)['attributes']).to eq(
        # { 'token' => user.access_token.token }
        # )
      end
    end
  end
end
