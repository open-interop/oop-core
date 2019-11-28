# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::V1::DevicesController, type: :controller do
  before do
    request.headers['X-Core-Token'] = Rails.configuration.oop[:services_token]
  end

  describe 'GET #auth' do
    context 'returns a success response' do
      before do
        get(:auth, params: {})
      end

      it { expect(response).to be_successful }
    end

    context 'cannot authenticate' do
      before { request.headers['X-Core-Token'] = 'asdasda' }

      before do
        get(:auth, params: {})
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #temprs' do
    before do
      allow_any_instance_of(Device).to(
        receive(:bunny_connection).and_return(BunnyMock.new.start)
      )
    end

    let(:device_tempr) { FactoryBot.create(:device_tempr) }
    let(:device) { device_tempr.device }

    context 'returns a success response' do
      before do
        get(:temprs, params: { id: device.id })
      end

      it { expect(response).to be_successful }
    end

    context 'return not found' do
      before do
        get(:temprs, params: { id: 'asd' })
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
