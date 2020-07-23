require 'rails_helper'

RSpec.describe Device, type: :model do
  let!(:device) { FactoryBot.create(:device) }

  context 'with authentication_path set' do
    before do
      device.authentication_path = '/asd'
      device.save
    end

    it { expect(device.valid?).to be(true) }
    it do
      expect(device.authentication).to eq(
        'path' => '/asd',
        'hostname' => 'test.host'
      )
    end
  end

  context 'with authentication_headers set' do
    before do
      device.authentication_path = nil
      device.authentication_headers = [['X-Token', '123']]
      device.save
    end

    it { expect(device.valid?).to be(true) }
    it { expect(device.authentication).to eq({
      'headers.x-token' => '123',
      'hostname' => 'test.host'
    })}
  end

  context 'with authentication_query set' do
    before do
      device.authentication_path = nil
      device.authentication_query = [['authentication_token', '987']]
      device.save
    end

    it { expect(device.valid?).to be(true) }
    it do
      expect(device.authentication).to eq(
        'query.authentication_token' => '987',
        'hostname' => 'test.host'
      )
    end
  end

  context 'with no authentication set' do
    before { device.authentication_path = nil }
    it { expect(device.valid?).to be(false) }
  end

  context 'with duplicate authentication_path' do
    let(:device_two) { FactoryBot.build(:device, authentication_path: '/') }

    it { expect(device_two).to_not be_valid }

    context 'on another account' do
      let(:account_two) do
        FactoryBot.create(:account, hostname: 'test-two.host')
      end

      let(:site) { FactoryBot.create(:site, account: account_two) }

      let(:device_group) do
        FactoryBot.create(:device_group, account: account_two)
      end

      before do
        device_two.device_group = device_group
        device_two.site = site
        device_two.account = account_two
      end

      it { expect(device_two).to be_valid }
    end
  end

  context 'with children' do
    let!(:transmissions) do
      Array.new(2) do
        FactoryBot.create(:transmission, device: device)
      end
    end

    it do
      expect do
        device.destroy
      end.to change(Device, :count).by(0)
    end

    it { expect(device.destroy).to eq(false) }

    it do
      expect do
        device.destroy
      end.to change(Transmission, :count).by(0)
    end

    context 'once children are removed' do
      before { transmissions.each(&:destroy) }

      it do
        expect do
          device.destroy
        end.to change(Device, :count).by(-1)
      end

      it { expect(device.destroy).to_not eq(false) }
    end
  end

  describe '#tempr_url' do
    it { expect(device.tempr_url).to eq("http://test.host:8888/services/v1/devices/#{device.id}/temprs") }
  end
end
