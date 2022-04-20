# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AccountController, type: :controller do

  let(:valid_attributes) do
    { interface_port: "8080", interface_scheme: "http://" }
  end

  describe 'GET #show' do
    context 'returns a success response' do
      before do
        get :show
      end

      it { expect(response).to be_successful }
    end

    context 'returns correct hostname' do
      before do
        get :show
      end

      it { expect(JSON.parse(response.body)["hostname"]).to eq("test.host") }
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'New Name' } }

      context 'updates the current account' do
        before do
          put :update, params: { account: new_attributes }
          get :show
        end

        it { expect(JSON.parse(response.body)["name"]).to eq('New Name') }
      end

      context 'renders a JSON response with the account details' do
        before do
          put :update, params: { account: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { hostname: 'not.set' } }

      context 'hostname not updated' do
        before do
          put :update, params: { account: invalid_attributes }
          get :show
        end

        it { expect(JSON.parse(response.body)["hostname"]).to_not eq('not.set') }
      end

      context 'renders an error response for the account' do
        before do
          put :update, params: { not_an_account: { hostname: '' } }
        end

        it { expect(response).to have_http_status(:internal_server_error) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end
end
