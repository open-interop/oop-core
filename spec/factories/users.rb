FactoryBot.define do
  factory :user do
    account
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
end
