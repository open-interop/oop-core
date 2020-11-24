# frozen_string_literal: true

module Services
  module V1
    class SchedulesController < ServicesController
      before_action :find_schedule

      # GET /services/v1/schedules
      def index
        render json:
          SchedulePresenter.collection_for_microservices(
            Schedule.includes(:account).active
          )
      end

      # GET /services/v1/schedules/:id/temprs
      def temprs
        render json:
          Rails.cache.fetch(
            [@schedule.id, 'services/temprs/device'],
            expires_in: 1.hour,
            race_condition_ttl: 5.seconds
          ) { # Used due to a bug with do/end block
            TemprPresenter.collection_for_microservices(
              @schedule.id,
              @schedule.temprs,
              :schedule
            ).to_json
          }
      end

      private

      def find_schedule
        return if params[:id].blank?

        @schedule =
          Rails.cache.fetch(
            [params[:id], 'services/schedules'],
            expires_in: 1.hour,
            race_condition_ttl: 5.seconds
          ) { # Used due to a bug with do/end block
            Schedule.active.find(params[:id])
          }
      end
    end
  end
end
