# frozen_string_literal: true

module Services
  module V1
    class DevicesController < ServicesController
      before_action :find_device

      # GET /services/v1/devices/auth
      def auth
        render json:
          Device.includes(:account, :site).active
                .to_json(only: %i[id], methods: %i[authentication])
      end

      # GET /services/v1/devices/:id/temprs
      def temprs
        render json:
          TemprPresenter.collection_for_microservices(
            @device.id,
            @device.temprs
          )
      end

      private

      def find_device
        return if params[:id].blank?

        @device = Device.active.find(params[:id])
      end
    end
  end
end
