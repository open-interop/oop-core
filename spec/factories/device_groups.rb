FactoryBot.define do
  factory :device_group do
    account { Account.first || create(:account) }
    name { "Device Group One" }
    description { Faker::Lorem.paragraph }
  end
end
