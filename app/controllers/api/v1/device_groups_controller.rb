# frozen_string_literal: true

module Api
  module V1
    # DeviceGroups controller
    # REST actions inherited from API::V1::BaseController
    class DeviceGroupsController < Api::V1::BaseController
      # GET /api/v1/device_groups
      def index
        @device_groups =
          DeviceGroupFilter.records(
            params,
            scope: current_account
          )

        render(
          json: DeviceGroupPresenter.collection(@device_groups, params[:page]),
          status: :ok
        )
      end

      private

      def record_association
        :device_groups
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'DeviceGroup'
      end

      def record_params
        params.require(:device_group).permit(:name, :description)
      end
    end
  end
end
