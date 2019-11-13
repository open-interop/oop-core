# frozen_string_literal: true

module Api
  module V1
    class TemprsController < ApplicationController
      before_action :find_tempr

      # GET /api/v1/temprs
      def index
        @temprs = TemprFilter.records(params, scope: current_account)

        render json:
          TemprPresenter.collection(@temprs, params[:page]), status: :ok
      end

      # GET /api/v1/temprs/:id
      def show
        render json: @tempr
      end

      # POST /api/v1/temprs
      def create
        @tempr = current_account.temprs.build(tempr_params)

        if @tempr.save
          render json: @tempr, status: :created
        else
          render json: @tempr.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/temprs/:id
      def update
        if @tempr.update(tempr_params)
          render json: @tempr
        else
          render json: @tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/temprs/:id
      def destroy
        @tempr.destroy
        render nothing: true, status: 200
      end

      # POST /api/v1/temprs/:id/preview
      def preview
        @renderer = OpenInterop::TemprRenderer.new(
          tempr_params[:example_transmission],
          tempr_params[:template]
        )

        @renderer.render

        if @renderer.json_response['rendered']['body'].blank?
          render json: ''
        elsif @renderer.json_response['rendered']['body']['language']
          render json: @renderer.json_response['rendered']['body']['body']
        else
          render json: @renderer.json_response['rendered']['body']
        end
      end

      # GET /api/v1/temprs/:id/history
      def history
        render json:
          AuditablePresenter.collection(@tempr.audits, params[:page]), status: :ok
      end

      private

      def find_tempr
        return if params[:id].blank?

        @tempr = current_account.temprs.find(params[:id])
      end

      def tempr_params
        params.require(:tempr).permit(
          :name,
          :description,
          :device_group_id,
          :device_id,
          :tempr_id,
          :endpoint_type,
          :queue_response,
          :queue_request,
          :example_transmission,
          { template: {} }
        )
      end
    end
  end
end
