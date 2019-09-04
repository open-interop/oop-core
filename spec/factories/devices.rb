FactoryBot.define do
  factory :device do
    account { Account.first || create(:account) }
    device_group { DeviceGroup.first || create(:device_group) }
    site { Site.first || create(:site) }
    name { 'Device test' }
    authentication_path { '/' }
  end
end
