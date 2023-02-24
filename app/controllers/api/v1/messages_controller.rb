# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
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

      # POST /api/v1/messages/:id/retry
      def retry
        @message.retry(@message)
        render json: @message
      end

      private

      def find_message
        return if params[:id].blank?

        @message = current_account.messages.find(params[:id])
      end

    end
  end
end
