class AccessToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  after_initialize :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex(10)
      break unless AccessToken.exists?(token: token)
    end
  end
end
