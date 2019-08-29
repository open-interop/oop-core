# frozen_string_literal: true

module Services
  module V1
    class DevicesController < ServicesController
      before_action :find_device

      # GET /devices/auth
      def auth
        render json: Device.includes(:account).active.to_json(only: %i[id], methods: %i[hostname authentication])
      end

      # GET /devices/:id/temprs
      def temprs
        render json:
          {
            ttl: 10_000,
            data: @device.device_temprs.as_json
          }
      end

      private

      def find_device
        return if params[:id].blank?

        @device = Device.find(params[:id])
      end
    end
  end
end
