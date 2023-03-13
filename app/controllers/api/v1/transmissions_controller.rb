# frozen_string_literal: true

module Api
  module V1
    class TransmissionsController < ApplicationController
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

      # POST /api/v1/transmissions/:id/retry
      def retry
        if @transmission.retry!
          render json: @transmission
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      private

      def find_transmission
        return if params[:id].blank?

        @transmission = current_account.transmissions.find(params[:id])
      end
    end
  end
end
