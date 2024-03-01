class ApplicationController < ActionController::API

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  # include JsonapiErrorsHandler
  # ErrorMapper.map_errors!({
  #     'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  # })
  # rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  private

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer": "/code" },
      "title" => "Authentication code is invalid",
      "detail" => "You must provide a valid code to exchange for a token"
}
  render json: { "errors" => [ error ] }, status: 401
  end
end
