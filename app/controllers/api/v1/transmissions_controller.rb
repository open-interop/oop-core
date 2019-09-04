# frozen_string_literal: true

module Api
  module V1
    class TransmissionsController < ApplicationController
      before_action :find_device
      before_action :find_transmission

      # GET /api/v1/transmissions
      def index
        @transmissions = @device.transmissions

        render json: @transmissions.to_json
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
    end
  end
end
