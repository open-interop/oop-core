# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DeviceGroupsController, type: :controller do
  let!(:device_group) { FactoryBot.create(:device_group) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:device_group)
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'returns a success response' do
      before do
        get :show, params: { id: device_group.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #history' do
    context 'returns a success response' do
      before do
        get :history, params: { id: device_group.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DeviceGroup' do
        expect do
          post :create, params: { device_group: valid_attributes }
        end.to change(DeviceGroup, :count).by(1)
      end

      context 'renders a JSON response with the new device_group' do
        before do
          post :create, params: { device_group: valid_attributes }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the new device_group' do

        before do
          post :create, params: { device_group: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'New Name' } }

      context 'updates the requested device_group' do
        before do
          put :update, params: { id: device_group.to_param, device_group: new_attributes }
          device_group.reload
        end

        it { expect(device_group.name).to eq('New Name') }
      end

      context 'renders a JSON response with the device_group' do
        before do
          put :update, params: { id: device_group.to_param, device_group: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the device_group' do
        before do
          put :update, params: { id: device_group.to_param, device_group: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested device_group' do
      expect {
        delete :destroy, params: { id: device_group.to_param }
      }.to change(DeviceGroup, :count).by(-1)
    end
  end
end
