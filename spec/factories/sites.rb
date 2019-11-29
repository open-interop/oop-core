FactoryBot.define do
  factory :site do
    account { Account.first || create(:account) }
    name { Faker::Nation.capital_city }
  end
end
