# frozen_string_literal: true

module Api
  module V1
    class DeviceTemprsController < ApplicationController
      before_action :find_device, except: %i[index]
      before_action :find_tempr, except: %i[index]
      before_action :find_device_tempr

      # GET /api/v1/devices_temprs
      def index
        @device_temprs =
          DeviceTemprFilter.records(
            params
          )

        render json:
          DeviceTemprPresenter.collection(
            @device_temprs,
            params[:page]
          ), status: :ok
      end

      # POST /api/v1/devices_temprs?device_id=:device_id&tempr_id=:tempr_id
      def create
        @device_tempr =
          DeviceTempr.new(
            device_id: @device.id,
            tempr_id: @tempr.id
          )

        if @device_tempr.save
          render json: @device_tempr.to_json(only: %i[id device_id tempr_id]), status: :created
        else
          render json: @device_tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/devices_temprs/:id
      # Must provide ?device_id and ?tempr_id
      def destroy
        if @device_tempr.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      private

      def find_device
        @device = current_account.devices.find(params[:device_id])
      end

      def find_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])
      end

      def find_device_tempr
        return if params[:id].blank?

        @device_tempr =
          @device.device_temprs
                 .where(tempr_id: @tempr.id)
                 .find(params[:id])
      end
    end
  end
end
