# frozen_string_literal: true

module Api
  module V1
    # Temprs controller
    # REST actions inherited from API::V1::BaseController
    class TemprsController < Api::V1::BaseController
      # GET /api/v1/temprs
      def index
        @temprs = TemprFilter.records(params, scope: current_account)

        render json:
          TemprPresenter.collection(@temprs, params[:page]), status: :ok
      end

      # POST /api/v1/temprs/preview
      def preview
        @renderer = OpenInterop::TemprRenderer.new(
          record_params[:example_transmission] || '',
          record_params[:template]
        )

        @renderer.render

        render json: @renderer.json_response
      end

      private

      def record_association
        :temprs
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Tempr'
      end

      def record_params
        params.require(:tempr).permit(
          :name,
          :description,
          :device_group_id,
          :device_id,
          :tempr_id,
          :endpoint_type,
          :queue_response,
          :queue_request,
          :save_console,
          :example_transmission,
          :notes,
          { template: {} }
        )
      end
    end
  end
end
