FactoryBot.define do
  factory :package do
    name { 'Test Package' }
  end
end

# == Schema Information
#
# Table name: packages
#
#  id                  :bigint           not null, primary key
#  device_groups_limit :integer          default(0)
#  devices_limit       :integer          default(0)
#  layers_limit        :integer          default(0)
#  name                :string
#  schedules_limit     :integer          default(0)
#  sites_limit         :integer          default(0)
#  temprs_limit        :integer          default(0)
#  users_limit         :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
