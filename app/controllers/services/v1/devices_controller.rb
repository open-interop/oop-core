# frozen_string_literal: true

module Services
  module V1
    class DevicesController < ServicesController
      before_action :find_device

      # GET /services/v1/devices/auth
      def auth
        render json:
          Device.includes(:account, :site).active
                .to_json(only: %i[id], methods: %i[authentication site_info])
      end

      # GET /services/v1/devices/:id/temprs
      def temprs
        render json:
          {
            ttl: 10_000,
            data: @device.device_temprs
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
