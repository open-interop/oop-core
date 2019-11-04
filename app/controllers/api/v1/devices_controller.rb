# frozen_string_literal: true

module Api
  module V1
    class DevicesController < ApplicationController
      before_action :find_device

      # GET /api/v1/devices
      def index
        @devices = DeviceFilter.records(params, scope: current_account)

        render json:
          DevicePresenter.collection(@devices, params[:page]), status: :ok
      end

      # GET /api/v1/devices/:id
      def show
        render json: @device
      end

      # POST /api/v1/devices
      def create
        @device = current_account.devices.build(device_params)

        if @device.save
          render json: @device, status: :created
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/devices/:id
      def update
        if @device.update(device_params)
          render json: @device
        else
          render json: @device.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/devices/:id
      def destroy
        @device.destroy
      end

      # POST /api/v1/devices/:id/assign_tempr
      def assign_tempr
        @tempr = @device.device_group.temprs.find(params[:tempr_id])

        if @device.assign_tempr(@tempr, device_tempr_params)
          render nothing: true, status: :created
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      private

      def find_device
        return if params[:id].blank?

        @device = current_account.devices.find(params[:id])
      end

      def device_params
        params.require(:device).permit(
          :device_group_id,
          :site_id,
          :name,
          :authentication_path,
          :authentication_headers,
          :authentication_query,
          :longitude,
          :latitude,
          :time_zone,
          :active,
          authentication_headers: [[]],
          authentication_query: [[]]
        ).tap do |whitelist|
          whitelist[:authentication_headers] =
            params[:device][:authentication_headers]

          whitelist[:authentication_query] =
            params[:device][:authentication_query]
        end
      end

      def device_tempr_params
        params.fetch(:device_tempr).permit(
          :endpoint_type,
          :queue_response,
          :options,
          options: %i[host port path request_method protocol headers]
        )
      end
    end
  end
end
