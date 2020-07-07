# frozen_string_literal: true

module Services
  module V1
    class DevicesController < ServicesController
      before_action :find_device

      # GET /services/v1/devices/auth
      def auth
        render json:
          Device.includes(:account, :site).active
                .to_json(only: %i[id], methods: %i[authentication tempr_url])
      end

      # GET /services/v1/devices/:id/temprs
      def temprs
        render json:
          Rails.cache.fetch(
            [@device, 'services/temprs'],
            expires_in: Rails.configuration.oop[:tempr_cache_ttl],
            race_condition_ttl: 5.seconds
          ) {
            TemprPresenter.collection_for_microservices(
              @device.id,
              @device.temprs
            ).to_json
          }
      end

      private

      def find_device
        return if params[:id].blank?

        @device =
          Rails.cache.fetch(
            [params[:id], 'services/devices'],
            expires_in: Rails.configuration.oop[:tempr_cache_ttl],
            race_condition_ttl: 5.seconds
          ) {
            Device.active.find(params[:id])
          }
      end
    end
  end
end
