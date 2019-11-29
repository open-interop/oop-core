# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { User.first }

  describe 'POST #create' do
    before do
      controller.request.headers['Authorization'] = nil
    end

    context 'with a good password' do
      before do
        post(:create, params: { email: user.email, password: 'password' })
      end

      it { expect(response).to be_successful }
    end

    context 'with a bad password' do
      before do
        post(:create, params: { email: user.email, password: 'badpassword' })
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with a bad username and password' do
      before do
        post(:create, params: { email: 'a@mail.com', password: 'badpassword' })
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #me' do
    context 'with a valid token' do
      before do
        get(:me, params: {})
      end

      let(:json_body) { JSON.parse(response.body) }

      it { expect(response).to be_successful }

      it do
        expect(json_body.keys).to(
          include('id', 'email', 'time_zone', 'created_at', 'updated_at')
        )
      end

      it { expect(json_body['id']).to eq(user.id) }
      it { expect(json_body['email']).to eq(user.email) }
      it { expect(json_body['time_zone']).to eq(user.time_zone) }
      it { expect(json_body['created_at']).to eq(user.created_at.as_json) }
      it { expect(json_body['updated_at']).to eq(user.updated_at.as_json) }
    end

    context 'without a valid token' do
      before do
        controller.request.headers['Authorization'] =
          'badtoken'

        get(:me, params: {})
      end

      let(:json_body) { JSON.parse(response.body) }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
