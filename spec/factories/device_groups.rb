FactoryBot.define do
  factory :device_group do
    account { Account.first || create(:account) }
    name { Faker::Cosmere.aon }
    description { Faker::Lorem.paragraph }
  end
end

# == Schema Information
#
# Table name: device_groups
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
