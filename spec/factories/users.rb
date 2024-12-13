FactoryBot.define do
  factory :user do
    name { "John Doe" }
    sequence(:email) { |n| "user#{n}@example.com" } # Gera emails únicos
    password { "password" }
  end
end
