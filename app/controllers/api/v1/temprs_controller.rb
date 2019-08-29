# frozen_string_literal: true

module Api
  module V1
    class TemprsController < ApplicationController
      before_action :find_device_group
      before_action :find_tempr

      # GET /device_groups/:device_group_id/temprs
      def index
        @temprs = @device_group.temprs.all

        render json: @temprs
      end

      # GET /device_groups/:device_group_id/temprs/:id
      def show
        render json: @tempr
      end

      # POST /device_groups/:device_group_id/temprs
      def create
        @tempr = @device_group.temprs.build(tempr_params)

        if @tempr.save
          render json: @tempr, status: :created, location: @tempr
        else
          render json: @tempr.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /device_groups/:device_group_id/temprs/:id
      def update
        if @tempr.update(tempr_params)
          render json: @tempr
        else
          render json: @tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /device_groups/:device_group_id/temprs/:id
      def destroy
        @tempr.destroy
      end

      private

      def find_device_group
        @device_group =
          current_account.device_groups.find(params[:device_group_id])
      end

      def find_tempr
        return if params[:id].blank?
        @tempr = @device_group.temprs.find(params[:id])
      end

      def tempr_params
        params.require(:tempr).permit(
          :name,
          :description,
          :body
        ).tap do |whitelist|
          whitelist[:body] = params[:tempr][:body]
        end
      end
    end
  end
end
