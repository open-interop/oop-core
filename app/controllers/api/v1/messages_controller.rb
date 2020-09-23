# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_device_id_filter
      before_action :find_message

      # GET /api/v1/messages
      def index
        @messages =
          MessageFilter.records(
            params,
            scope: current_account
          )

        render json:
          MessagePresenter.collection(@messages, params[:page]), status: :ok
      end

      # GET /api/v1/messages/1
      def show
        render json: @message
      end

      private

      def set_device_id_filter
        if params[:device_id].present? && params[:filter].present?
          params[:filter][:device_id] = params[:device_id]
        else
          params[:filter] = { device_id: params[:device_id] }
        end
      end

      def find_message
        return if params[:id].blank?

        @message = current_account.messages.find(params[:id])
      end
    end
  end
end
