FactoryBot.define do
  factory :schedule do
    account { Account.first || create(:account) }
    name { 'Schedule test' }
    hour { '12' }
    active { true }
  end
end
