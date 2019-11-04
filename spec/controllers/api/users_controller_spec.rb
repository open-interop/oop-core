# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:user)
  end

  let(:invalid_attributes) do
    { email: nil }
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
        get :show, params: { id: user.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      context 'renders a JSON response with the new user' do
        before do
          post :create, params: { user: valid_attributes }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the new user' do

        before do
          post :create, params: { user: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { email: 'example@example.com' } }

      context 'updates the requested user' do
        before do
          put :update, params: { id: user.to_param, user: new_attributes }
          user.reload
        end

        it { expect(user.email).to eq('example@example.com') }
      end

      context 'renders a JSON response with the user' do
        before do
          put :update, params: { id: user.to_param, user: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the user' do
        before do
          put :update, params: { id: user.to_param, user: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user.to_param }
      }.to change(User, :count).by(-1)
    end
  end
end
