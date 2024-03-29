require 'rails_helper'

shared_examples_for "unauthorized_requests" do
  let(:authentication_error) do
    {
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" => "Authentication code is invalid",
      "detail" => "You must provide a valid code to exchange for a token"
    }
  end

  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['errors']).to include(authentication_error)
  end
end

shared_examples_for 'forbidden_requests' do
  let(:authorization_error) do
    {
      "errors" => [{
        "status" => "403",
        "source" => { "pointer" => "/headers/authorization" },
        "title" => "You are not authorized",
        "detail" => "You are not authorized to access this resource"
      }]
    }
  end

  it 'should return 403 status code' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it 'should return proper error json' do
    subject
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).to eq(authorization_error)
  end
end
