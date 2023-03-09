# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransmissionFilter do
  describe '#records' do
    let(:device) { FactoryBot.create(:device) }
    let(:account) { device.account }

    let(:device_tempr) { FactoryBot.create(:device_tempr, device: device, tempr: FactoryBot.create(:tempr)) }
    let(:device_tempr2) { FactoryBot.create(:device_tempr, device: device, tempr: FactoryBot.create(:tempr)) }

    let!(:transmissions) do
      [
        FactoryBot.create(
          :transmission,
          device: device,
          message_uuid: 'a-specific-message-12345678910'
        ),
        FactoryBot.create(
          :transmission,
          device: device,
          transmission_uuid: 'a-specific-transmission-12345678910'
        ),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device),
        FactoryBot.create(:transmission, device: device, status: ''),
        FactoryBot.create(:transmission, device: device, status: nil)
      ]
    end

    context 'permits the required parameters' do
      it do
        expect(described_class.new({}).all_filterable_fields).to(
          eq(
            [
              'id', 'status', 'tempr_id', 'device_id', 'schedule_id',
              'message_id', 'message_uuid', 'transmission_uuid',
              'state', 'custom_field_a', 'custom_field_b','success', 'discarded', 'retried',
              { 'transmitted_at' => %w[gt gteq lt lteq] },
              { 'created_at' => %w[gt gteq lt lteq] },
              { 'updated_at' => %w[gt gteq lt lteq] },
              { 'sort' => %w[field direction] }
            ]
          )
        )
      end
    end

    context 'nothing filtered' do
      let(:records) do
        TransmissionFilter.records(
          { },
          scope: account
        )
      end

      it { expect(device.transmissions.size).to eq(10) }
      it { expect(records.size).to eq(10) }
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
          scope: account
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
          scope: account
        )
      end

      it { expect(records.size).to eq(1) }
    end

    context 'filter by status' do
      context 'is null' do
         let(:params) do
          ActionController::Parameters.new(
            filter: { status: nil }
          )
        end

        let(:records) do
          TransmissionFilter.records(
            params,
            scope: account
          )
        end

        it { expect(records.size).to eq(2) }
      end

      context 'is empty string' do
        let(:params) do
          ActionController::Parameters.new(
            filter: { status: '' }
          )
        end

        let(:records) do
          TransmissionFilter.records(
            params,
            scope: account
          )
        end

        it { expect(records.size).to eq(2) }
      end
    end
  end
end
