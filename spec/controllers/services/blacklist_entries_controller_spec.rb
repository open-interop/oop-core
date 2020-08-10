# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::V1::BlacklistEntriesController, type: :controller do
  before do
    request.headers['X-Core-Token'] = Rails.configuration.oop[:services_token]
  end

  describe 'GET #index' do
    context 'returns a success response' do
      before do
        get(:index, params: {})
      end

      it { expect(response).to be_successful }
    end

    context 'cannot authenticate' do
      before { request.headers['X-Core-Token'] = 'asdasda' }

      before do
        get(:index, params: {})
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end

