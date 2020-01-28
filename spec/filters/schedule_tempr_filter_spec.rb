# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleTemprFilter do
  describe '#records' do
    let(:schedule) { FactoryBot.create(:schedule) }
    let(:tempr) { FactoryBot.create(:tempr) }
    let(:tempr2) { FactoryBot.create(:tempr) }
    let(:tempr3) { FactoryBot.create(:tempr) }
    let(:tempr4) { FactoryBot.create(:tempr) }

    let!(:schedule_temprs) do
      [
        FactoryBot.create(:schedule_tempr, schedule: schedule, tempr: tempr),
        FactoryBot.create(:schedule_tempr, schedule: schedule, tempr: tempr2),
        FactoryBot.create(:schedule_tempr, schedule: schedule, tempr: tempr3),
        FactoryBot.create(:schedule_tempr, schedule: schedule, tempr: tempr4)
      ]
    end

    context 'nothing filtered' do
      let(:records) do
        ScheduleTemprFilter.records({})
      end

      it { expect(schedule.schedule_temprs.size).to eq(4) }
      it { expect(records.size).to eq(0) }
    end

    context 'filter by schedule_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { schedule_id: schedule.id }
        )
      end

      let(:records) do
        ScheduleTemprFilter.records(params)
      end

      it { expect(schedule.schedule_temprs.size).to eq(4) }
      it { expect(records.size).to eq(4) }
    end

    context 'filter by tempr_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { tempr_id: tempr.id }
        )
      end

      let(:records) do
        ScheduleTemprFilter.records(params)
      end

      it { expect(schedule.schedule_temprs.size).to eq(4) }
      it { expect(records.size).to eq(1) }
    end

    context 'filter by schedule_id and tempr_id' do
      let(:params) do
        ActionController::Parameters.new(
          filter: { schedule_id: schedule.id, tempr_id: tempr.id }
        )
      end

      let(:records) do
        ScheduleTemprFilter.records(params)
      end

      it { expect(schedule.schedule_temprs.size).to eq(4) }
      it { expect(records.size).to eq(1) }
    end
  end
end
