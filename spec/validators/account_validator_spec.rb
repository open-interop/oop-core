# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountValidator do
  describe '#validate' do
    let(:account_one) { FactoryBot.create(:account) }
    let(:account_two) { FactoryBot.create(:account, hostname: 'testtwo.host') }

    let(:site) { FactoryBot.create(:site, account: account_one) }

    context 'with site and device on different accounts' do
      let(:site) { FactoryBot.create(:site, account: account_two) }

      let(:device) do
        FactoryBot.build(:device, site: site, account: account_one)
      end

      it { expect(device).to be_invalid }
    end

    context 'with site and device on the same account' do
      let(:device) do
        FactoryBot.build(:device, site: site, account: account_one)
      end

      it { expect(device).to be_valid }
    end

    context 'with device_group and device on different accounts' do
      let(:device_group) do
        FactoryBot.create(:device_group, account: account_two)
      end

      let(:device) do
        FactoryBot.build(:device, site: site, device_group: device_group, account: account_one)
      end

      it { expect(device).to be_invalid }
    end

    context 'with device_group and device on the same account' do
      let(:device_group) do
        FactoryBot.create(:device_group, account: account_one)
      end

      let(:device) do
        FactoryBot.build(:device, site: site, device_group: device_group, account: account_one)
      end

      it { expect(device).to be_valid }
    end

    context 'with device_group and tempr on different accounts' do
      let(:device_group) do
        FactoryBot.create(:device_group, account: account_two)
      end

      let(:tempr) do
        FactoryBot.build(:tempr, device_group: device_group, account: account_one)
      end

      it { expect(tempr).to be_invalid }
    end

    context 'with device_group and tempr on the same account' do
      let(:device_group) do
        FactoryBot.create(:device_group, account: account_one)
      end

      let(:tempr) do
        FactoryBot.build(:tempr, device_group: device_group, account: account_one)
      end

      it { expect(tempr).to be_valid }
    end

    context 'with site and site on different accounts' do
      let(:site_one) do
        FactoryBot.create(:site, account: account_two)
      end

      let(:site_two) do
        FactoryBot.build(:site, site: site_one, account: account_one)
      end

      it { expect(site_two).to be_invalid }
    end

    context 'with site and site on the same account' do
      let(:site_one) do
        FactoryBot.create(:site, account: account_one)
      end

      let(:site_two) do
        FactoryBot.build(:site, site: site_one, account: account_one)
      end

      it { expect(site_two).to be_valid }
    end
  end
end
