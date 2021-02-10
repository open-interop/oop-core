# frozen_string_literal: true

module Api
  module V1
    # Packages controller
    # REST actions inherited from API::V1::BaseController
    class PackagesController < Api::V1::BaseController
      # GET /api/v1/packages
      def index
        @packages = PackageFilter.records(params)

        render json:
          PackagePresenter.collection(@packages, params[:page]), status: :ok
      end

      # POST /api/v1/resources
      def create
        @record = current_account.send(record_association).build(record_params)

        if @record.save
          render json: @record.to_json(record_json_attributes), status: :created
        else
          render json: @record.errors, status: :unprocessable_entity
        end
      end

      private

      def record_association
        :packages
      end

      def record_params
        params.require(:package).permit(
          :name,
          :device_groups_limit,
          :devices_limit,
          :layers_limit,
          :schedules_limit,
          :sites_limit,
          :temprs_limit,
          :users_limit
        )
      end
    end
  end
end
