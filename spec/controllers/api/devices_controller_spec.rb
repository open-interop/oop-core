# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DevicesController, type: :controller do
  before do
    allow_any_instance_of(Device).to(
      receive(:bunny_connection).and_return(BunnyMock.new.start)
    )
  end

  let!(:device) { FactoryBot.create(:device) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(
      :device,
      device_group_id: device.device_group_id,
      site_id: device.site_id
    )
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:device, name: nil)
  end

  describe 'GET #index' do
    context 'returns a success response' do
      before { get :index, params: {} }
      it { expect(response).to be_successful }
    end
  end

  describe 'GET #show' do
    context 'returns a success response' do
      before do
        get :show, params: { id: device.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Device' do
        expect do
          post :create, params: { device: valid_attributes }
        end.to change(Device, :count).by(1)
      end

      context 'renders a JSON response with the new device' do
        before { post :create, params: { device: valid_attributes } }
        it { expect(response).to have_http_status(:created) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'with invalid params' do
        context 'renders a JSON response with errors for the new association' do
          before { post :create, params: { device: invalid_attributes } }
          it { expect(response).to have_http_status(:unprocessable_entity) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end
        end
      end
    end
  end

  describe 'POST #assign_tempr' do
    let(:tempr) { FactoryBot.create(:tempr, device_group: device.device_group) }

    context 'with valid params' do
      it 'creates a new DeviceTempr' do
        expect do
          post :assign_tempr, params: { id: device.id, tempr_id: tempr.id }
        end.to change(DeviceTempr, :count).by(1)
      end

      context 'renders a JSON response with the new device tempr' do
        before { post :assign_tempr, params: { id: device.id, tempr_id: tempr.id } }
        it { expect(response).to have_http_status(:created) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the new association' do
        before { post :assign_tempr, params: { id: device.id } }
        it { expect(response).to have_http_status(:not_found) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'New Name' } }

      context 'updates the requested device' do
        before do
          put :update, params: { id: device.to_param, device: new_attributes }
          device.reload
        end

        it { expect(device.name).to eq('New Name') }
      end

      context 'renders a JSON response with the device' do
        before do
          put :update, params: { id: device.to_param, device: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the device' do
        before do
          put :update, params: { id: device.to_param, device: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested device' do
      expect do
        delete :destroy, params: { id: device.to_param }
      end.to change(Device, :count).by(-1)
    end
  end
end
