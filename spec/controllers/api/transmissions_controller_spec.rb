# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransmissionsController, type: :controller do
  let(:transmission) { FactoryBot.create(:transmission) }

  describe 'GET #index' do
    context 'returns a success response' do
      before do
        get(:index, params: { filter: { device_id: transmission.device.to_param } })
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #show' do
    context 'returns a success response' do
      before do
        get(:show, params: { filter: { device_id: transmission.device.to_param }, id: transmission.to_param })
      end

      it { expect(response).to be_successful }
    end
  end
end
