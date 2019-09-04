FactoryBot.define do
  factory :user do
    account { Account.first || create(:account) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
end
