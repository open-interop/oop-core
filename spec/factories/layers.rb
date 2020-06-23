FactoryBot.define do
  factory :layer do
    account { Account.first || FactoryBot.create(:account) }
    name { 'Test Layer' }
    reference { Faker::Alphanumeric.unique.alpha(number: 10) }
    script { 'module.exports = { "key1" : "some-value", "key2": "some-other-value" }' }
  end
end
