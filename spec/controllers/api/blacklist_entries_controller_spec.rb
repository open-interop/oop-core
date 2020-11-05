# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BlacklistEntriesController, type: :controller do
  let!(:blacklist_entry) { FactoryBot.create(:blacklist_entry) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(
      :blacklist_entry
    )
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(
      :blacklist_entry,
      ip_literal: nil,
      ip_range: nil,
      path_literal: nil,
      path_regex: nil,
      headers: nil
    )
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
        get :show, params: { id: blacklist_entry.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #audit_logs' do
    context 'returns a success response' do
      before do
        get :audit_logs, params: { id: blacklist_entry.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Blacklist Entry' do
        expect do
          post :create, params: { blacklist_entry: valid_attributes }
        end.to change(BlacklistEntry, :count).by(1)
      end

      context 'renders a JSON response with the new blacklist entry' do
        before { post :create, params: { blacklist_entry: valid_attributes } }
        it { expect(response).to have_http_status(:created) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'with invalid params' do
        context 'renders a JSON response with errors for the new association' do
          before { post :create, params: { blacklist_entry: invalid_attributes } }
          it { expect(response).to have_http_status(:unprocessable_entity) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
        let(:new_attributes) { { ip_literal: '127.0.0.1' } }

      context 'updates the requested blacklist entry' do
        before do
          put :update, params: { id: blacklist_entry.to_param, blacklist_entry: new_attributes }
          blacklist_entry.reload
        end

        it { expect(blacklist_entry.ip_literal).to eq('127.0.0.1') }
      end

      context 'renders a JSON response with the blacklist entry' do
        before do
          put :update, params: { id: blacklist_entry.to_param, blacklist_entry: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the blacklist entry' do
        before do
          put :update, params: { id: blacklist_entry.to_param, blacklist_entry: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the requested blacklist entry' do
      it do
        expect do
          delete :destroy, params: { id: blacklist_entry.to_param }
        end.to change(BlacklistEntry, :count).by(-1)
      end
    end

    context 'responds' do
      before { delete :destroy, params: { id: blacklist_entry.to_param } }

      it { expect(response.status).to eq(204) }
    end
  end
end
