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

    @access_token = @user.access_token
    puts "Access Token from Authenticator: #{@access_token}"

  end

private

  def exchange_code_for_token
    @token ||= client.exchange_code_for_token(@code)
    @access_token = @token if @token.present?
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
    puts "User data hash: #{@user_data.inspect}"
    @user_data
  end

  def prepare_user
    @user ||= User.find_or_initialize_by(login: user_data[:login]) do |user|
      user.attributes = user_data
      user.provider = 'github'
      # user.create_access_token(token: @token) #to save to the databa
      # user.build_access_token(token: @token) #generates token, but doesn't pass it to the user
    end
    puts "User is a new record: #{@user.new_record?}"
    @user.save! if @user.new_record?
    puts "User is saved: #{@user.persisted?}"
    @user.create_access_token(token: @token) if @user.persisted?
    puts "User access token after association: #{@user.access_token.inspect}"
  end


  def user_authorized?
   true
  end
end
