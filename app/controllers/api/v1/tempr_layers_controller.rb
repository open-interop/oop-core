# frozen_string_literal: true

module Api
  module V1
    class TemprLayersController < ApplicationController
      before_action :find_layer, except: %i[index]
      before_action :find_tempr, except: %i[index]
      before_action :find_tempr_layer

      # GET /api/v1/tempr_layers
      def index
        @tempr_layers =
          TemprLayerFilter.records(
            params
          )

        render json:
          TemprLayerPresenter.collection(
            @tempr_layers,
            params[:page]
          ), status: :ok
      end

      # POST /api/v1/tempr_layers?layer_id=:layer_id&tempr_id=:tempr_id
      def create
        @layer_tempr =
          TemprLayer.new(
            layer_id: @layer.id,
            tempr_id: @tempr.id
          )

        if @layer_tempr.save
          render json: @layer_tempr.to_json(only: %i[id layer_id tempr_id]), status: :created
        else
          render json: @layer_tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tempr_layers/:id
      # Must provide ?layer_id and ?tempr_id
      def destroy
        if @layer_tempr.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      private

      def find_layer
        @layer = current_account.layers.find(params[:layer_id])
      end

      def find_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])
      end

      def find_tempr_layer
        return if params[:id].blank?

        @layer_tempr =
          @layer.tempr_layers
                 .where(tempr_id: @tempr.id)
                 .find(params[:id])
      end
    end
  end
end
