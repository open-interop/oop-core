# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceTemprFilter do
  describe '#records' do
    let(:device) { FactoryBot.create(:device) }
    let(:tempr) { FactoryBot.create(:tempr) }
    let(:tempr2) { FactoryBot.create(:tempr) }
    let(:tempr3) { FactoryBot.create(:tempr) }
    let(:tempr4) { FactoryBot.create(:tempr) }

    let!(:device_temprs) do
      [
        FactoryBot.create(:device_tempr, device: device, tempr: tempr),
        FactoryBot.create(:device_tempr, device: device, tempr: tempr2),
        FactoryBot.create(:device_tempr, device: device, tempr: tempr3),
        FactoryBot.create(:device_tempr, device: device, tempr: tempr4)
      ]
    end

    context 'nothing filtered' do
      let(:records) do
        DeviceTemprFilter.records({})
      end

      it { expect(device.device_temprs.size).to eq(4) }
      it { expect(records.size).to eq(0) }
    end

    context 'filter by device_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { device_id: device.id }
        )
      end

      let(:records) do
        DeviceTemprFilter.records(params)
      end

      it { expect(device.device_temprs.size).to eq(4) }
      it { expect(records.size).to eq(4) }
    end

    context 'filter by tempr_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { tempr_id: tempr.id }
        )
      end

      let(:records) do
        DeviceTemprFilter.records(params)
      end

      it { expect(device.device_temprs.size).to eq(4) }
      it { expect(records.size).to eq(1) }
    end

    context 'filter by device_id and tempr_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { device_id: device.id, tempr_id: tempr.id }
        )
      end

      let(:records) do
        DeviceTemprFilter.records(params)
      end

      it { expect(device.device_temprs.size).to eq(4) }
      it { expect(records.size).to eq(1) }
    end
  end
end
