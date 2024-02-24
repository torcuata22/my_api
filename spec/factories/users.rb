FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "pperez#{n}" }
    name { "Pedro Perez" }
    url { "http://example.com" }
    avatar_url { "http://example.com/avatar" }
    provider { "github" }
  end
end
