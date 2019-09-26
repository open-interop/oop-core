# frozen_string_literal: true

module Api
  module V1
    class TransmissionsController < ApplicationController
      before_action :find_device
      before_action :find_transmission

      # GET /api/v1/transmissions
      def index
        @transmissions =
          @device.transmissions
                 .order('transmissions.created_at desc')

        filter_transmissions

        render json: TransmissionPresenter.collection(@transmissions, params[:page]), status: :ok
      end

      # GET /api/v1/transmissions/1
      def show
        render json: @transmission
      end

      private

      def find_device
        @device = current_account.devices.find(params[:device_id])
      end

      def find_transmission
        return if params[:id].blank?

        @transmission = @device.transmissions.find(params[:id])
      end

      def filter_transmissions
        %i[
          device_tempr_id message_uuid
          transmission_uuid success status
        ].each do |filter|
          params[filter].present? &&
            @transmissions = @transmissions.where(filter => params[filter])
        end
      end
    end
  end
end
