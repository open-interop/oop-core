# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TemprLayersController, type: :controller do
  let!(:tempr_layer) { FactoryBot.create(:tempr_layer) }
  let(:layer) { tempr_layer.layer }
  let(:tempr) { tempr_layer.tempr }
  let(:tempr2) { FactoryBot.create(:tempr) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { layer_id: layer.id, tempr_id: tempr.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TemprLayer' do
        expect do
          post :create, params: { layer_id: layer.id, tempr_id: tempr2.id }
        end.to change(TemprLayer, :count).by(1)
      end

      context 'renders a JSON response with the new tempr_layer' do
        before do
          post :create, params: { layer_id: layer.id, tempr_id: tempr2.id }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for a duplicate association' do
        before do
          post :create, params: { layer_id: layer.id, tempr_id: tempr.id }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end

      context 'renders a JSON response with errors when the layer is missing' do
        before do
          post :create, params: { layer_id: nil, tempr_id: tempr.id }
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end

      context 'renders a JSON response with errors when the tempr is missing' do
        before do
          post :create, params: { layer_id: layer.id, tempr_id: nil }
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tempr_layer' do
      expect do
        delete :destroy, params: { id: tempr_layer.to_param, layer_id: layer.id, tempr_id: tempr.id }
      end.to change(TemprLayer, :count).by(-1)
    end

    context 'renders nothing' do
      before do
        delete :destroy, params: { id: tempr_layer.to_param, layer_id: layer.id, tempr_id: tempr.id }
      end

      it { expect(response).to be_successful }
    end

    context 'without a layer' do
      before do
        delete :destroy, params: { id: tempr_layer.to_param, layer_id: nil, tempr_id: tempr.id }
      end

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'responds' do
      before do
        delete :destroy, params: { id: tempr_layer.to_param, layer_id: layer.id, tempr_id: tempr.id }
      end

      it { expect(response.status).to eq(204) }
    end
  end
end
