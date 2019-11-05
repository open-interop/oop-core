# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransmissionFilter do
  describe '#records' do
    let(:device) { FactoryBot.create(:device) }

    let(:device_tempr) { FactoryBot.create(:device_tempr, device: device, tempr: FactoryBot.create(:tempr)) }
    let(:device_tempr2) { FactoryBot.create(:device_tempr, device: device, tempr: FactoryBot.create(:tempr)) }

    let!(:transmissions) do
      [
        FactoryBot.create(
          :transmission,
          device_tempr: device_tempr,
          message_uuid: 'a-specific-message-12345678910'
        ),
        FactoryBot.create(
          :transmission,
          device_tempr: device_tempr,
          transmission_uuid: 'a-specific-transmission-12345678910'
        ),
        FactoryBot.create(:transmission, device_tempr: device_tempr),
        FactoryBot.create(:transmission, device_tempr: device_tempr),
        FactoryBot.create(:transmission, device_tempr: device_tempr),
        FactoryBot.create(:transmission, device_tempr: device_tempr2),
        FactoryBot.create(:transmission, device_tempr: device_tempr2),
        FactoryBot.create(:transmission, device_tempr: device_tempr2),
        FactoryBot.create(:transmission, device_tempr: device_tempr2),
        FactoryBot.create(:transmission, device_tempr: device_tempr2)
      ]
    end

    context 'nothing filtered' do
      let(:records) do
        TransmissionFilter.records(
          {},
          scope: device
        )
      end

      it { expect(device.transmissions.size).to eq(10) }
      it { expect(records.size).to eq(10) }
    end

    context 'filter by device_tempr_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { device_tempr_id: device_tempr2.id }
        )
      end

      let(:records) do
        TransmissionFilter.records(
          params,
          scope: device
        )
      end

      it { expect(records.size).to eq(5) }
    end

    context 'filter by message_uuid' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { message_uuid: 'a-specific-message' }
        )
      end

      let(:records) do
        TransmissionFilter.records(
          params,
          scope: device
        )
      end

      it { expect(records.size).to eq(1) }
    end

    context 'filter by transmission_uuid' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { transmission_uuid: 'a-specific-transmission' }
        )
      end

      let(:records) do
        TransmissionFilter.records(
          params,
          scope: device
        )
      end

      it { expect(records.size).to eq(1) }
    end
  end
end
