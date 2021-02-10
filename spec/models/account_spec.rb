require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#interface_address' do
    context 'with a standard http port' do
      let(:account) { FactoryBot.create(:account) }

      it { expect(account.interface_address).to eq("http://test.host:8888/") }
    end

    context 'with a non-standard port (int)' do
      let(:account) { FactoryBot.create(:account, interface_port: 8000) }

      it { expect(account.interface_address).to eq("http://test.host:8000/") }
    end

    context 'with a non-standard port (string)' do
      let(:account) { FactoryBot.create(:account, interface_port: '8000') }

      it { expect(account.interface_address).to eq("http://test.host:8000/") }
    end

    context 'with a non-standard path' do
      let(:account) { FactoryBot.create(:account, interface_path: '/oop') }

      it { expect(account.interface_address).to eq("http://test.host:8888/oop") }
    end
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(TRUE)
#  device_groups_limit :integer          default(0)
#  devices_limit       :integer          default(0)
#  hostname            :string
#  interface_path      :string
#  interface_port      :integer
#  interface_scheme    :string
#  layers_limit        :integer          default(0)
#  name                :string
#  schedules_limit     :integer          default(0)
#  sites_limit         :integer          default(0)
#  temprs_limit        :integer          default(0)
#  users_limit         :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#  package_id          :bigint
#
