# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SitesController, type: :controller do
  let!(:site) { FactoryBot.create(:site) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:site)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:site, name: nil)
  end

  describe 'GET #index' do
    context 'returns a success response' do
      before do
        get :index, params: { }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #show' do
    context 'returns a success response' do
      before do
        get :show, params: { id: site.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #audit_logs' do
    context 'returns a success response' do
      before do
        get :audit_logs, params: { id: site.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Site' do
        expect {
          post :create, params: { site: valid_attributes }
        }.to change(Site, :count).by(1)
      end

      context 'renders a JSON response with the new site' do
        before do
          post :create, params: { site: valid_attributes }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the new site' do
        before do
          post :create, params: { site: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'New Name' }
      end

      context 'updates the requested site' do
        before do
          put :update, params: { id: site.to_param, site: new_attributes }
          site.reload
        end

        it { expect(site.name).to eq('New Name') }
      end

      context 'renders a JSON response with the site' do
        before do
          put :update, params: { id: site.to_param, site: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the site' do
        before do
          put :update, params: { id: site.to_param, site: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the requested site' do
      it do
        expect {
          delete :destroy, params: { id: site.to_param }
        }.to change(Site, :count).by(-1)
      end
    end

    context 'responds' do
      before { delete :destroy, params: { id: site.to_param } }

      it { expect(response.status).to eq(204) }
    end
  end

  describe 'GET #sidebar' do
    context 'returns a success response' do
      before do
        get :sidebar, params: { side_id: site.to_param }
      end

      let(:json_response) { JSON.parse(response.body) }

      it { expect(json_response['sites'].size).to eq(1) }
      it { expect(json_response['sites'].first['id']).to eq(site.id) }
      it { expect(json_response['sites'].first['name']).to eq(site.name) }

      it { expect(response).to be_successful }
    end
  end
end
