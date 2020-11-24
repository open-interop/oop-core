# frozen_string_literal: true

module Api
  module V1
    # Layers controller
    # REST actions inherited from API::V1::BaseController
    class LayersController < Api::V1::BaseController
      # GET /api/v1/layers
      def index
        @layers = LayerFilter.records(params, scope: current_account)

        render json:
          LayerPresenter.collection(@layers, params[:page]), status: :ok
      end

      # POST /api/v1/layers/:id/assign_tempr
      def assign_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])

        @tempr_layer = @record.tempr_layers.create(tempr: @tempr)

        render json: @tempr_layer, status: :created
      end

      private

      def record_association
        :layers
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Layer'
      end

      def record_params
        params.require(:layer).permit(
          :name,
          :reference,
          :script,
          :archived
        )
      end
    end
  end
end
