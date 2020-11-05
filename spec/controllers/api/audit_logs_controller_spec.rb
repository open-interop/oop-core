# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuditLogsController, type: :controller do
  describe 'GET #index' do
    context 'response' do
      before do
        get(:index)
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #show' do
    let(:user) { User.first }
    let(:audit) { user.audits.first }

    before do
      get(:show, params: { id: audit.id })
    end

    let(:json_body) { JSON.parse(response.body) }

    context 'response' do
      it { expect(response).to be_successful }
    end

    context '#auditable_id' do
      it { expect(json_body['auditable_id']).to eq(user.id) }
    end

    context '#auditable_type' do
      it { expect(json_body['auditable_type']).to eq('User') }
    end

    context '#associated_id' do
      it { expect(json_body['associated_id']).to eq(user.account.id) }
    end

    context '#associated_type' do
      it { expect(json_body['associated_type']).to eq('Account') }
    end

    context '#action' do
      it { expect(json_body['action']).to eq('create') }
    end

    context '#version' do
      it { expect(json_body['version']).to eq(1) }
    end
  end
end
