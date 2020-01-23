# frozen_string_literal: true

module Services
  module V1
    class SchedulesController < ServicesController
      before_action :find_schedule

      # GET /services/v1/schedules
      def index
        render json:
          Schedule.includes(:account, :site).active
                  .to_json(only: %i[id name], methods: %i[schedule tempr_url])
      end

      # GET /services/v1/schedules/:id/temprs
      def temprs
        render json:
          TemprPresenter.collection_for_microservices(
            @schedule.id,
            @schedule.temprs,
            :schedule
          )
      end

      private

      def find_schedule
        return if params[:id].blank?

        @schedule = Schedule.active.find(params[:id])
      end
    end
  end
end
