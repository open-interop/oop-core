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
#  custom_field_a     :string
#  custom_field_b     :string
#  ip_address         :string
#  origin_type        :string
#  retried            :boolean          default(FALSE)
#  retried_at         :datetime
#  state              :string           default("unknown")
#  transmission_count :integer          default(0)
#  uuid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  device_id          :integer
#  origin_id          :integer
#  schedule_id        :integer
#
# Indexes
#
#  index_messages_on_account_id                 (account_id)
#  index_messages_on_created_at                 (created_at)
#  index_messages_on_device_id                  (device_id)
#  index_messages_on_origin_id_and_origin_type  (origin_id,origin_type)
#  index_messages_on_retried_at                 (retried_at)
#  index_messages_on_schedule_id                (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (schedule_id => schedules.id)
#
