# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SchedulesController, type: :controller do
  let!(:schedule) { FactoryBot.create(:schedule) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(
      :schedule
    )
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:schedule, name: nil)
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
        get :show, params: { id: schedule.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'GET #audit_logs' do
    context 'returns a success response' do
      before do
        get :audit_logs, params: { id: schedule.to_param }
      end

      it { expect(response).to be_successful }
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Schedule' do
        expect do
          post :create, params: { schedule: valid_attributes }
        end.to change(Schedule, :count).by(1)
      end

      context 'renders a JSON response with the new schedule' do
        before { post :create, params: { schedule: valid_attributes } }
        it { expect(response).to have_http_status(:created) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'with invalid params' do
        context 'renders a JSON response with errors for the new association' do
          before { post :create, params: { schedule: invalid_attributes } }
          it { expect(response).to have_http_status(:unprocessable_entity) }
          it do
            expect(response.content_type).to eq('application/json; charset=utf-8')
          end
        end
      end
    end
  end

  describe 'POST #assign_tempr' do
    let(:tempr) { FactoryBot.create(:tempr) }

    context 'with valid params' do
      it 'creates a new ScheduleTempr' do
        expect do
          post :assign_tempr, params: { id: schedule.id, tempr_id: tempr.id }
        end.to change(ScheduleTempr, :count).by(1)
      end

      context 'renders a JSON response with the new schedule tempr' do
        before { post :assign_tempr, params: { id: schedule.id, tempr_id: tempr.id } }
        it { expect(response).to have_http_status(:created) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the new association' do
        before { post :assign_tempr, params: { id: schedule.id } }
        it { expect(response).to have_http_status(:not_found) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'New Name' } }

      context 'updates the requested schedule' do
        before do
          put :update, params: { id: schedule.to_param, schedule: new_attributes }
          schedule.reload
        end

        it { expect(schedule.name).to eq('New Name') }
      end

      context 'renders a JSON response with the schedule' do
        before do
          put :update, params: { id: schedule.to_param, schedule: valid_attributes }
        end

        it { expect(response).to have_http_status(:ok) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'with invalid params' do
      context 'renders a JSON response with errors for the schedule' do
        before do
          put :update, params: { id: schedule.to_param, schedule: invalid_attributes }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the requested schedule' do
      it do
        expect do
          delete :destroy, params: { id: schedule.to_param }
        end.to change(Schedule, :count).by(-1)
      end
    end

    context 'responds' do
      before { delete :destroy, params: { id: schedule.to_param } }

      it { expect(response.status).to eq(204) }
    end
  end
end
