# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuditsController, type: :controller do
  describe 'GET #index' do
    context 'returns a success response' do
      before do
        get(:index)
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #show' do
    context 'returns a success response' do
      let(:audit) { Audited::Audit.first }

      before do
        get(:show, params: { id: audit.id })
      end

      it { expect(response).to be_successful }
    end
  end
end
