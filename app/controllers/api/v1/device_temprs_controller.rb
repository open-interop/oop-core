# frozen_string_literal: true

module Api
  module V1
    class DeviceTemprsController < ApplicationController
      before_action :find_device
      before_action :find_device_tempr

      # GET /api/v1/device_temprs
      def index
        @device_temprs = @device.device_temprs

        render json: @device_temprs.to_json
      end

      # GET /api/v1/device_temprs/:id
      def show
        render json: @device_tempr
      end

      # POST /api/v1/device_temprs
      def create
        @device_tempr = @device.device_temprs.new(device_tempr_params)

        if @device_tempr.save
          render json: @device_tempr, status: :created, location: @device_tempr
        else
          render json: @device_tempr.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/device_temprs/:id
      def update
        if @device_tempr.update(device_tempr_params)
          render json: @device_tempr
        else
          render json: @device_tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/device_temprs/:id
      def destroy
        @device_tempr.destroy
      end

      private

      def find_device
        @device = current_account.devices.find(params[:device_id])
      end

      def find_device_tempr
        return if params[:id].blank?
        @device_tempr = @device.device_temprs.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def device_tempr_params
        params.require(:device_tempr).permit(
          :device_id,
          :tempr_id,
          :endpoint_type,
          :queue_response,
          :options
        ).tap do |whitelist|
          whitelist[:options] = params[:device_tempr][:options]
        end
      end
    end
  end
end
