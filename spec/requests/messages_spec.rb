# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Messages', type: :request do
  describe 'GET /api/v1/messages' do
    let(:device) { FactoryBot.create(:device) }
    let(:schedule) { FactoryBot.create(:schedule) }
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
            api_v1_messages_path,
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
      let!(:messages) do
        Array.new(21) do
          FactoryBot.create(:message, device: device)
        end
      end

      context 'with default filters' do
        before do
          get(api_v1_messages_path(page: { count: true }), headers: authorization_headers)
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

    context 'on schedule with count param' do
      let!(:messages) do
        Array.new(21) do
          FactoryBot.create(:message, schedule: schedule)
        end
      end

      context 'with default filters' do
        before do
          get(api_v1_messages_path(page: { count: true }), headers: authorization_headers)
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
      let!(:messages) do
        Array.new(21) do
          FactoryBot.create(:message, device: device)
        end
      end

      context 'with default filters' do
        before do
          get(api_v1_messages_path, headers: authorization_headers)
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
          it { expect(json_body['data'][0]['id']).to eq(messages.last.id) }
          it { expect(json_body['data'][0]['uuid']).to eq(messages.last.uuid) }
        end
      end

      context 'with origin_type filter' do
        before do
          get(
            api_v1_messages_path,
            params: { filter: { origin_type: 'Device' } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        let(:matching_messages) do
          messages.select { |t| t.origin_type == 'Device' }
        end

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        it { expect(json_body['total_records']).to eq(matching_messages.size) }
      end

      context 'with device_id filter' do
        before do
          get(
            api_v1_messages_path,
            params: { filter: { device_id: device.id } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        let(:matching_messages) { messages.select { |t| t.device_id == device.id } }

        it { expect(response).to have_http_status(200) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        it { expect(json_body['total_records']).to eq(matching_messages.size) }
      end

      context 'with datetime filter' do
        let(:filtered_datetime) { Time.now - 1.day }

        before do
          FactoryBot.create(:message, created_at: Time.now - 2.days)

          get(
            api_v1_messages_path,
            params: { filter: { created_at: { lt: filtered_datetime } } },
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

      context 'with sort by created_at' do
        let!(:old_transmission) do
          FactoryBot.create(:message, created_at: Time.now - 2.days)
        end

        context 'ascending' do
          before do
            get(
              api_v1_messages_path,
              params: {
                filter: {
                  sort: {
                    field: 'created_at',
                    direction: 'asc'
                  }
                }
              },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to(
              eq('application/json; charset=utf-8')
            )
          end

          it { expect(json_body['data'][0]['id']).to eq(old_transmission.id) }
        end

        context 'descending' do
          before do
            get(
              api_v1_messages_path,
              params: {
                filter: {
                  sort: {
                    field: 'created_at',
                    direction: 'desc'
                  }
                }
              },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to(
              eq('application/json; charset=utf-8')
            )
          end

          it do
            expect(json_body['data'][0]['id']).to_not eq(old_transmission.id)
          end
        end

        context 'missing' do
          before do
            get(
              api_v1_messages_path,
              params: {
                filter: {
                  sort: {
                    field: 'created_at'
                  }
                }
              },
              headers: authorization_headers
            )
          end

          let(:json_body) { JSON.parse(response.body) }

          it { expect(response).to have_http_status(200) }
          it do
            expect(response.content_type).to(
              eq('application/json; charset=utf-8')
            )
          end

          it do
            expect(json_body['data'][0]['id']).to_not eq(old_transmission.id)
          end
        end
      end

      context 'with all records' do
        before do
          get(
            api_v1_messages_path,
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
