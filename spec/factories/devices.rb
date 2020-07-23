FactoryBot.define do
  factory :device do
    account { Account.first || create(:account) }
    device_group { DeviceGroup.first || create(:device_group, account: account) }
    site { Site.first || create(:site, account: account) }
    name { 'Device test' }
    authentication_path { '/' }
  end
end
