# frozen_string_literal: true

module Api
  module V1
    class DevicesController < Api::V1Controller
      # GET /api/v1/devices
      def index
        @devices = DeviceFilter.records(params, scope: current_account)

        render json:
          DevicePresenter.collection(@devices, params[:page]), status: :ok
      end

      # POST /api/v1/devices/:id/assign_tempr
      def assign_tempr
        @tempr = @record.device_group.temprs.find(params[:tempr_id])

        @device_tempr = @record.device_temprs.create(tempr: @tempr)

        render json: @device_tempr, status: :created
      end

      private

      def record_association
        :devices
      end

      def record_params
        params.require(:device).permit(
          :device_group_id,
          :site_id,
          :name,
          :authentication_path,
          :authentication_headers,
          :authentication_query,
          :longitude,
          :latitude,
          :time_zone,
          :active,
          authentication_headers: [[]],
          authentication_query: [[]]
        ).tap do |whitelist|
          whitelist[:authentication_headers] =
            params[:device][:authentication_headers]

          whitelist[:authentication_query] =
            params[:device][:authentication_query]
        end
      end
    end
  end
end
