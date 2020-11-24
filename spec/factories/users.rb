FactoryBot.define do
  factory :user do
    account { Account.first || create(:account) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email                       :string
#  password_digest             :string
#  password_reset_requested_at :datetime
#  password_reset_token        :string
#  time_zone                   :string           default("London")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  account_id                  :integer
#
