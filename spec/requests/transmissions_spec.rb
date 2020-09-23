# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Transmissions', type: :request do
  describe 'GET /api/v1/transmissions' do
    let(:device) { FactoryBot.create(:device) }
    let(:account) { Account.first }
    let(:api_user) { FactoryBot.create(:user, account: account) }
    let(:authorization_headers) do
      {
        Authorization: JsonWebToken.encode(user_id: api_user.id)
      }
    end

    context 'with filters with no records' do
      context 'with all records' do
        before do
          get(
            api_v1_transmissions_path,
            params: { page: { size: -1 } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(json_body['total_records']).to eq(0) }
        it { expect(json_body['number_of_pages']).to eq(0) }
        it { expect(json_body['page']['number']).to eq(1) }
        it { expect(json_body['page']['size']).to eq(20) }
        it { expect(json_body['data'].size).to eq(0) }
      end
    end

    context 'with count param' do
      let!(:transmissions) do
        Array.new(21) do
          FactoryBot.create(:transmission, device: device)
        end
      end

      context 'with default filters' do
        before do
          get(api_v1_transmissions_path(page: { count: true }), headers: authorization_headers)
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end

        it { expect(json_body['total_records']).to eq(21) }
        it { expect(json_body['number_of_pages']).to eq(2) }
        it { expect(json_body['page']['number']).to eq(1) }
        it { expect(json_body['page']['size']).to eq(20) }
        it { expect(json_body['data']).to eq(nil) }
      end
    end

    context 'with filters' do
      let!(:transmissions) do
        Array.new(21) do
          FactoryBot.create(:transmission, device: device)
        end
      end

      context 'with default filters' do
        before do
          get(api_v1_transmissions_path, headers: authorization_headers)
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end

        it { expect(json_body['total_records']).to eq(21) }
        it { expect(json_body['number_of_pages']).to eq(2) }
        it { expect(json_body['page']['number']).to eq(1) }
        it { expect(json_body['page']['size']).to eq(20) }
        it { expect(json_body['data'].size).to eq(20) }

        describe 'matches the latest transmission' do
          it { expect(json_body['data'][0]['id']).to eq(transmissions.last.id) }
          it { expect(json_body['data'][0]['message_uuid']).to eq(transmissions.last.message_uuid) }
          it { expect(json_body['data'][0]['transmission_uuid']).to eq(transmissions.last.transmission_uuid) }
          it { expect(json_body['data'][0]['success']).to eq(transmissions.last.success) }
          it { expect(json_body['data'][0]['status']).to eq(transmissions.last.status) }
          it { expect(json_body['data'][0]['transmitted_at']).to eq(transmissions.last.transmitted_at.as_json) }
          it { expect(json_body['data'][0]['response_body']).to eq(transmissions.last.response_body) }
          it { expect(json_body['data'][0]['request_body']).to eq(transmissions.last.request_body) }
        end
      end

      context 'with status filter' do
        before do
          get(
            api_v1_transmissions_path,
            params: { filter: { status: 200 } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        let(:matching_transmissions) { transmissions.select { |t| t.status == 200 } }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        it { expect(json_body['total_records']).to eq(matching_transmissions.size) }
      end

      context 'with success filter' do
        before do
          get(
            api_v1_transmissions_path,
            params: { filter: { success: false } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        let(:matching_transmissions) { transmissions.select { |t| t.success == false } }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        it { expect(json_body['total_records']).to eq(matching_transmissions.size) }
      end

      context 'with datetime filter' do
        let(:filtered_datetime) { Time.now - 1.day }

        before do
          FactoryBot.create(:transmission, transmitted_at: Time.now - 2.days)

          get(
            api_v1_transmissions_path,
            params: { filter: { transmitted_at: { lt: filtered_datetime } } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        it { expect(json_body['total_records']).to eq(1) }
      end

      context 'with sort by transmitted_at' do
        let!(:old_transmission) do
          FactoryBot.create(:transmission, transmitted_at: Time.now - 2.days)
        end

        context 'ascending' do
          before do
            get(
              api_v1_transmissions_path,
              params: { filter: { sort: { field: 'transmitted_at', direction: 'asc' } } },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end

          it { expect(json_body['data'][0]['id']).to eq(old_transmission.id) }
        end

        context 'descending' do
          before do
            get(
              api_v1_transmissions_path,
              params: { filter: { sort: { field: 'transmitted_at', direction: 'desc' } } },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end

          it { expect(json_body['data'][0]['id']).to_not eq(old_transmission.id) }
        end

        context 'missing' do
          before do
            get(
              api_v1_transmissions_path,
              params: { filter: { sort: { field: 'transmitted_at' } } },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end

          it { expect(json_body['data'][0]['id']).to_not eq(old_transmission.id) }
        end
      end

      context 'with all records' do
        before do
          get(
            api_v1_transmissions_path,
            params: { page: { size: -1 } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(json_body['total_records']).to eq(21) }
        it { expect(json_body['number_of_pages']).to eq(1) }
        it { expect(json_body['page']['number']).to eq(1) }
        it { expect(json_body['page']['size']).to eq(21) }
        it { expect(json_body['data'].size).to eq(21) }
      end
    end
  end
end
