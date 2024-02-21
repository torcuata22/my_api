require 'rails_helper'

RSpec.describe ArticlesController do
  describe '#index' do
    it "returns a success response" do
      get '/articles'
      #expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end
  end
end
