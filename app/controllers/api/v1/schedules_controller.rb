# frozen_string_literal: true

module Api
  module V1
    # Schedules controller
    # REST actions inherited from API::V1::BaseController
    class SchedulesController < Api::V1::BaseController
      # GET /api/v1/schedules
      def index
        @schedules = ScheduleFilter.records(params, scope: current_account)

        render json:
          SchedulePresenter.collection(@schedules, params[:page]), status: :ok
      end

      # POST /api/v1/schedules/:id/assign_tempr
      def assign_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])

        @schedule_tempr = @record.schedule_temprs.create(tempr: @tempr)

        render json: @schedule_tempr, status: :created
      end

      private

      def record_association
        :schedules
      end

      def check_limit?
        current_account.schedules_limit == 0 || 
          current_account.schedules_limit > current_account.schedules.length
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Schedule'
      end

      def record_params
        params.require(:schedule).permit(
          :name,
          :active,
          :minute,
          :hour,
          :day_of_week,
          :day_of_month,
          :month_of_year,
          :year,
          :queue_messages
        )
      end
    end
  end
end
