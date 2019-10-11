# frozen_string_literal: true

module Api
  module V1
    class DeviceTemprsController < ApplicationController
      before_action :find_device_group
      before_action :find_device_tempr

      # GET /api/v1/device_groups/:device_group_id/device_temprs
      def index
        @device_temprs =
          DeviceTemprFilter.records(
            params,
            scope: @device_group
          )

        render(
          json: DeviceTemprPresenter.collection(@device_temprs, params[:page]),
          status: :ok
        )
      end

      # GET /api/v1/device_groups/:device_group_id/device_temprs/:id
      def show
        render json: @device_tempr
      end

      # POST /api/v1/device_groups/:device_group_id/device_temprs
      def create
        @device_tempr = DeviceTempr.new(device_tempr_params)

        if @device_tempr.save
          render json: @device_tempr, status: :created
        else
          render json: @device_tempr.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/device_groups/:device_group_id/device_temprs/:id
      def update
        if @device_tempr.update(device_tempr_params)
          render json: @device_tempr
        else
          render json: @device_tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/device_groups/:device_group_id/device_temprs/:id
      def destroy
        @device_tempr.destroy
      end

      private

      def find_device_group
        @device_group =
          current_account.device_groups.find(params[:device_group_id])
      end

      def find_device_tempr
        return if params[:id].blank?

        @device_tempr =
          DeviceTempr.includes(device: :device_group)
                     .where(
                       id: params[:id],
                       device_groups: { id: @device_group.id }
                     )
                     .references(:device_groups).first

        @device_tempr.blank? &&
          raise(ActiveRecord::RecordNotFound)
      end

      # Only allow a trusted parameter "white list" through.
      def device_tempr_params
        params.require(:device_tempr).permit(
          :device_id,
          :tempr_id,
          :endpoint_type,
          :queue_response,
          { options: {} }
        )
      end
    end
  end
end
