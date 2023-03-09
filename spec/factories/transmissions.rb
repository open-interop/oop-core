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
#  response_body     :text
#  retried           :boolean         default(FALSE)
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
