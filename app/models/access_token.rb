class AccessToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  after_initialize :generate_token

  private

  def generate_token
    puts "generating token........."
    loop do

      puts "Generated token: #{token}"
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)
      self.token = SecureRandom.hex(10)
    end
  end

end
