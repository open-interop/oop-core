# frozen_string_literal: true

module Api
  module V1
    class DeviceGroupsController < ApplicationController
      before_action :find_device_group, only: %i[show update destroy]

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

      # GET /api/v1/device_groups/:id
      def show
        render json: @device_group
      end

      # POST /api/v1/device_groups
      def create
        @device_group = current_account.device_groups.build(device_group_params)

        if @device_group.save
          render json: @device_group, status: :created
        else
          render json: @device_group.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/device_groups/:id
      def update
        if @device_group.update(device_group_params)
          render json: @device_group
        else
          render json: @device_group.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/device_groups/:id
      def destroy
        @device_group.destroy
      end

      private

      def find_device_group
        @device_group = current_account.device_groups.find(params[:id])
      end

      def device_group_params
        params.fetch(:device_group).permit(:name, :description)
      end
    end
  end
end
