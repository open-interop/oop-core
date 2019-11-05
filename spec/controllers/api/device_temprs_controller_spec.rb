# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DeviceTemprsController, type: :controller do
  let!(:device_tempr) { FactoryBot.create(:device_tempr) }
  let(:device) { device_tempr.device }
  let(:tempr) { device_tempr.tempr }
  let(:tempr2) { FactoryBot.create(:tempr) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { device_id: device.id, tempr_id: tempr.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DeviceTempr' do
        expect do
          post :create, params: { device_id: device.id, tempr_id: tempr2.id }
        end.to change(DeviceTempr, :count).by(1)
      end

      context 'renders a JSON response with the new device_tempr' do
        before do
          post :create, params: { device_id: device.id, tempr_id: tempr2.id }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for a duplicate association' do
        before do
          post :create, params: { device_id: device.id, tempr_id: tempr.id }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end

      context 'renders a JSON response with errors when the device is missing' do
        before do
          post :create, params: { device_id: nil, tempr_id: tempr.id }
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end

      context 'renders a JSON response with errors when the tempr is missing' do
        before do
          post :create, params: { device_id: device.id, tempr_id: nil }
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested device_tempr' do
      expect {
        delete :destroy, params: { id: device_tempr.to_param, device_id: device.id, tempr_id: tempr.id }
      }.to change(DeviceTempr, :count).by(-1)
    end
  end
end
