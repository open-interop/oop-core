FactoryBot.define do
  factory :device_group do
    account { Account.first || create(:account) }
    name { Faker::Cosmere.aon }
    description { Faker::Lorem.paragraph }
  end
end
