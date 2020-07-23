# frozen_string_literal: true

module Api
  module V1
    class TransmissionsController < ApplicationController
      before_action :set_device_id_filter
      before_action :find_transmission

      # GET /api/v1/transmissions
      def index
        @transmissions =
          TransmissionFilter.records(
            params,
            scope: current_account
          )

        render json:
          TransmissionPresenter.collection(@transmissions, params[:page]), status: :ok
      end

      # GET /api/v1/transmissions/1
      def show
        render json: @transmission
      end

      private

      def set_device_id_filter
        if params[:device_id].present? && params[:filter].present?
          params[:filter][:device_id] = params[:device_id]
        else
          params[:filter] = { device_id: params[:device_id] }
        end
      end

      def find_transmission
        return if params[:id].blank?

        @transmission = current_account.transmissions.find(params[:id])
      end
    end
  end
end
