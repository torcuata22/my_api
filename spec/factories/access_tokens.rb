FactoryBot.define do
  factory :access_token do
    association :user
    token { "MyString" }
  end
end
