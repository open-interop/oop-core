FactoryBot.define do
  factory :message do
    body { { 'test-body' => 'something' } }
    uuid { Faker::Internet.uuid }
    account { Account.first || create(:account) }
    device { Device.first || create(:device, account: account) }
    origin { device }
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                 :bigint           not null, primary key
#  body               :text
#  ip_address         :string
#  origin_type        :string
#  status             :string
#  transmission_count :integer          default(0)
#  uuid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint
#  device_id          :integer
#  origin_id          :integer
#  schedule_id        :integer
#
# Indexes
#
#  index_messages_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
