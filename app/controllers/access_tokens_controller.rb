class AccessTokensController < ApplicationController

  def create
        authenticator = UserAuthenticator.new(params[:code])
        authenticator.perform
        render json: authenticator.access_token, status: :created, serializer: AccessTokenSerializer
        puts "Response body: #{response.body}"
  end

  def destroy
    # raise ApplicationController::AuthorizationError
    raise AuthorizationError
    render json: { errors: [{ title: 'Authorization Error', detail: 'You are not authorized to access this resource' }] }, status: :forbidden
  end
end






# class AccessTokensController < ApplicationController

#   def create
#     authenticator = UserAuthenticator.new(params[:code])
#     authenticator.perform
#     render json: authenticator.access_token, status: :created, serializer: AccessTokenSerializer
#     puts "Response body: #{response.body}"
#   end

#   def destroy
#     raise AuthorizationError
#   end
# end
