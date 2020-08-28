FactoryBot.define do
  factory :layer do
    account { Account.first || FactoryBot.create(:account) }
    name { 'Test Layer' }
    reference { Faker::Alphanumeric.unique.alpha(number: 10) }
    script { 'module.exports = { "key1" : "some-value", "key2": "some-other-value" }' }
  end
end

# == Schema Information
#
# Table name: layers
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE)
#  name       :string
#  reference  :string
#  script     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
