# frozen_string_literal: true

module Api
  module V1
    class LayersController < ApplicationController
      before_action :find_layer

      # GET /api/v1/layers
      def index
        @layers = LayerFilter.records(params, scope: current_account)

        render json:
          LayerPresenter.collection(@layers, params[:page]), status: :ok
      end

      # GET /api/v1/layers/:id
      def show
        render json: @layer
      end

      # POST /api/v1/layers
      def create
        @layer = current_account.layers.build(layer_params)

        if @layer.save
          render json: @layer, status: :created
        else
          render json: @layer.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/layers/:id
      def update
        if @layer.update(layer_params)
          render json: @layer
        else
          render json: @layer.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/layers/:id
      def destroy
        if @layer.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # POST /api/v1/layers/:id/assign_tempr
      def assign_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])

        @tempr_layer = @layer.tempr_layers.create(tempr: @tempr)

        render json: @tempr_layer, status: :created
      end

      # GET /api/v1/layers/:id/history
      def history
        render json:
          AuditablePresenter.collection(@layer.audits, params[:page]), status: :ok
      end

      private

      def find_layer
        return if params[:id].blank?

        @layer = current_account.layers.find(params[:id])
      end

      def layer_params
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
