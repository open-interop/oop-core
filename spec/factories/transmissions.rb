FactoryBot.define do
  factory :transmission do
    account { Account.first || create(:account) }
    device { Device.first || create(:device, account: account) }
    message do
      Message.first || create(:message, device: device, account: account)
    end
    message_uuid { Faker::Internet.uuid }
    transmission_uuid { Faker::Internet.uuid }
    success { [true, false].sample }
    status { [200, 201, 400].sample }
    discarded { [true, false].sample }
    state { 'successful' }
    transmitted_at { Time.now }
    request_body { { somedata: 'moredata' }.to_json }
    response_body { { event: 'success' }.to_json }
  end
end

# == Schema Information
#
# Table name: transmissions
#
#  id                :bigint           not null, primary key
#  custom_field_a    :string
#  custom_field_b    :string
#  discarded         :boolean          default(FALSE)
#  message_uuid      :string
#  request_body      :text
#  request_headers   :text
#  request_host      :string
#  request_method    :string
#  request_path      :string
#  request_port      :integer
#  request_protocol  :string
#  response_body     :text
#  retried           :boolean          default(FALSE)
#  retried_at        :datetime
#  state             :string
#  status            :integer
#  success           :boolean
#  transmission_uuid :string
#  transmitted_at    :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  device_id         :integer
#  message_id        :integer
#  schedule_id       :integer
#  tempr_id          :integer
#
# Indexes
#
#  index_transmissions_on_account_id  (account_id)
#  index_transmissions_on_created_at  (created_at)
#  index_transmissions_on_device_id   (device_id)
#  index_transmissions_on_message_id  (message_id)
#  index_transmissions_on_retried_at  (retried_at)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (message_id => messages.id)
#
