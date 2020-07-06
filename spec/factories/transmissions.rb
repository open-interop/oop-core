FactoryBot.define do
  factory :transmission do
    account { Account.first || create(:account) }
    device { Device.first || create(:device, account: account) }
    message_uuid { Faker::Internet.uuid }
    transmission_uuid { Faker::Internet.uuid }
    success { [true, false].sample }
    status { [200, 201, 400].sample }
    transmitted_at { Time.now }
    request_body { { somedata: 'moredata' }.to_json }
    response_body { { event: 'success' }.to_json }
  end
end
