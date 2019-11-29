FactoryBot.define do
  factory :transmission do
    device { Device.first || create(:device)}
    device_tempr { DeviceTempr.first || create(:device_tempr)}
    message_uuid { Faker::Internet.uuid }
    transmission_uuid { Faker::Internet.uuid }
    success { [true, false].sample }
    status { [200, 201, 400].sample }
    transmitted_at { Time.now }
    request_body { { somedata: 'moredata' }.to_json }
    response_body { { event: 'success' }.to_json }
  end
end
