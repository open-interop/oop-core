# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    account { Account.first || create(:account) }
    device_group do
      account.device_groups.first ||
        create(:device_group, account: account)
    end
    site { account.sites.first || create(:site, account: account) }
    name { 'Device test' }
    authentication_path { '/' }
  end
end

# == Schema Information
#
# Table name: devices
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  authentication_headers :text
#  authentication_path    :string
#  authentication_query   :text
#  latitude               :decimal(10, 6)
#  longitude              :decimal(10, 6)
#  name                   :string
#  queue_messages         :boolean          default(FALSE)
#  time_zone              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  device_group_id        :integer
#  site_id                :integer
#
