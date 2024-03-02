class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :user, :access_token

  def initialize(code)
    @code = code
  end

  def perform
    raise AuthenticationError, "Code is blank" if @code.blank?

    exchange_code_for_token
    raise AuthenticationError, "Invalid token" if @token.try(:error).present?

    prepare_user
    raise AuthenticationError, "User is not authorized" unless user_authorized?
  end

private

  def exchange_code_for_token
    @token ||= client.exchange_code_for_token(@code)
  end

  def client
    @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def user_data
    @user_data ||= Octokit::Client.new(
      access_token: @token
    ).user.to_h.slice(:login, :avatar_url, :url, :name)
  end

  def prepare_user
    @user ||= User.find_by(login: user_data[:login])
  end

  def user_authorized?
    # Assuming user roles are stored in a 'role' attribute of the User model
   true
  end
end



# class UserAuthenticator
#   class AuthenticationError < StandardError; end
#   attr_reader :user, :access_token

#   def initialize(code)
#     @code = code
#   end

#   def perform
#     raise AuthenticationError if @code.blank?
#     raise AuthenticationError if @token.try(:error).present?
#   end

#   private

#   def token
#     puts "Code:#{@code}" unless @token
#     @token ||= client.exchange_code_for_token(@code)
#     puts "Token received: #{token.inspect}" unless @token.nil?
#     @token
#   end

#   def client
#     @client ||= Octokit::Client.new(
#       client_id: ENV['GITHUB_CLIENT_ID'],
#       client_secret: ENV['GITHUB_CLIENT_SECRET']
#     )
#   end

#   def user_data
#     puts "Access Token: #{token}"
#     @user_data ||= Octokit::Client.new(
#       access_token: token
#     ).user.to_h.slice(:login, :avatar_url, :url, :name)
#     @user_data
#   end

#   def prepare_user
#     @user = if User.exists?(login: user_data[:login])
#       User.find_by(login: user_data[:login])
#     else
#       User.create(user_data.merge(provider: 'github'))
#     end
#   end
# end
