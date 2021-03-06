require 'rails_helper'

RSpec.describe Api::V1::TemprsController, type: :controller do
  let!(:device_group) { FactoryBot.create(:device_group) }
  let!(:tempr) { FactoryBot.create(:tempr, device_group: device_group) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(
      :tempr,
      device_group_id: device_group.id,
      templateable: nil,
      endpoint_type: 'http',
      template: FactoryBot.attributes_for(:http_template)
    )
  end

  let(:valid_attributes_for_tempr_tempr) do
    FactoryBot.attributes_for(
      :tempr,
      device_group_id: device_group.id,
      templateable: nil,
      endpoint_type: 'tempr',
      template: FactoryBot.attributes_for(:tempr_template)
    )
  end

  let(:invalid_attributes) { { name: nil } }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: tempr.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #audit_logs' do
    it 'returns a success response' do
      get :audit_logs, params: { id: tempr.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new http Tempr' do
        expect do
          post :create, params: { tempr: valid_attributes }
        end.to change(Tempr, :count).by(1)
      end

      it 'creates a new tempr Tempr' do
        expect do
          post :create, params: { tempr: valid_attributes_for_tempr_tempr }
        end.to change(Tempr, :count).by(1)
      end

      context 'renders a JSON response with the new tempr' do
        before do
          post :create, params: { tempr: valid_attributes }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      before do
        post :create, params: { tempr: invalid_attributes }
      end

      context 'renders a JSON response with errors for the new tempr' do
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'New Name' } }

      context 'updates the requested tempr' do
        before do
          put :update, params: { id: tempr.to_param, tempr: new_attributes }
          tempr.reload
        end

        it { expect(tempr.name).to eq('New Name') }
      end

      context 'renders a JSON response with the tempr' do
        before do
          put :update, params: { id: tempr.to_param, tempr: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the tempr' do
        before do
          put :update, params: { id: tempr.to_param, tempr: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'POST #preview' do
    context 'with valid params' do
      before do
        allow_any_instance_of(OpenInterop::TemprRenderer).to(
          receive(:json_response).and_return(
            'rendered' => {
              'host' => 'example.com',
              'port' => '80',
              'path' => '/test/some-value/some-other-value',
              'request_method' => 'POST',
              'protocol' => 'http',
              'headers' => {
                'Content-Type' => 'application/json'
              },
              'body' => {
                'body' => 'asd of this thing some-value and also some-other-value'
              }
            },
            'console' => ''
          )
        )
      end

      context 'renders a JSON response with the new tempr' do
        before do
          post :preview, params: {
            tempr: {
              example_transmission: tempr.example_transmission,
              template: tempr.template
            }
          }
        end

        let(:json_body) { JSON.parse(response.body) }

        it { expect(json_body['rendered']['body']['body']).to eq('asd of this thing some-value and also some-other-value') }
        it { expect(response).to be_successful }

        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(OpenInterop::TemprRenderer).to(
          receive(:json_response).and_return(
            'rendered' => {},
            'console' => ''
          )
        )
      end

      before do
        post :preview, params: {
          tempr: invalid_attributes
        }
      end

      context 'renders a JSON response with errors for the new tempr' do
        it { expect(response).to be_successful }
        it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the requested tempr' do
      it do
        expect do
          delete :destroy, params: {id: tempr.to_param}
        end.to change(Tempr, :count).by(-1)
      end
    end

    context 'responds' do
      before { delete :destroy, params: { id: tempr.to_param } }

      it { expect(response.status).to eq(204) }
    end
  end
end
