FactoryBot.define do
  factory :site do
    account { Account.first || create(:account) }
    name { Faker::Nation.capital_city }
  end
end

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  address        :string
#  city           :string
#  country        :string
#  description    :text
#  external_uuids :text
#  full_name      :string
#  latitude       :decimal(10, 6)
#  longitude      :decimal(10, 6)
#  name           :string
#  region         :string
#  state          :string
#  time_zone      :string
#  zip_code       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  site_id        :integer
#
