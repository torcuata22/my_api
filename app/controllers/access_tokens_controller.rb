class AccessTokensController < ApplicationController
  # rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    puts "create action triggered"
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    render json: authenticator.access_token, status: :created
  end
end
#   private

#   def authentication_error(exception)
#     error_message = {
#       "status" => "401",
#       "source" => { "pointer" => "/code" },
#       "title" => "Authentication error",
#       "detail" => exception.message
#     }
#     render json: { "errors" => [error_message] }, status: :unauthorized
#   end
# end
