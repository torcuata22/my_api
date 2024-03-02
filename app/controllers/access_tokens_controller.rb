class AccessTokensController < ApplicationController

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    render json: authenticator.access_token, status: :created, serializer: AccessTokenSerializer
    puts "Response body: #{response.body}"
  end
end
  # def create
  #   puts "create action triggered"
  #   authenticator = UserAuthenticator.new(params[:code])
  #   authenticator.perform
  #   result = serializer.new(authenticator.access_token)
  #   render json: result, status: :created
  #   # render json: { token: @access_token }, status: :created
  #   # render json: authenticator.access_token, status: :created
  # end
