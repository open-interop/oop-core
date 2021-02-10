# frozen_string_literal: true

module Api
  module V1
    # Devices controller
    # REST actions inherited from API::V1::BaseController
    class DevicesController < Api::V1::BaseController
      # GET /api/v1/devices
      def index
        @records = DeviceFilter.records(params, scope: current_account)

        render json:
          DevicePresenter.collection(@records, params[:page]), status: :ok
      end

      # DELETE /api/v1/devices/:id
      def destroy
        params[:force_delete] == 'true' &&
          @record.force_delete = true

        if @record.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # POST /api/v1/devices/:id/assign_tempr
      def assign_tempr
        @tempr = @record.device_group.temprs.find(params[:tempr_id])

        @record_tempr = @record.device_temprs.create(tempr: @tempr)

        render json: @record_tempr, status: :created
      end

      private

      def record_association
        :devices
      end

      def check_limit?
        current_account.devices_limit == 0 || current_account.devices_limit > current_account.devices.length
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Device'
      end

      def record_params
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
          :queue_messages,
          authentication_headers: [[]],
          authentication_query: [[]]
        ).tap do |whitelist|
          whitelist[:authentication_headers] =
            params[:device][:authentication_headers]

          whitelist[:authentication_query] =
            params[:device][:authentication_query]
        end
      end
    end
  end
end
