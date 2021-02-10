# frozen_string_literal: true

module ManagementApi
  module V1
    # Packages controller
    # REST actions inherited from ManagementAPI::V1::BaseController
    class PackagesController < ManagementApi::V1::BaseController
      before_action :find_record

      # GET /api/v1/packages
      def index
        @packages = PackageFilter.records(params)

        render json:
          PackagePresenter.collection(@packages, params[:page]), status: :ok
      end

      # SHOW /api/v1/packages/:id
      def show
        render json: @package.to_json({})
      end

      # POST /api/v1/packages
      def create
        @package = Package.create(record_params)

        if @package.save
          render json: @package.to_json({}), status: :created
        else
          render json: @package.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/packages/:id
      def update
        if @package.update(record_params)
          render json: @package
        else
          render json: @package.errors, status: :unprocessable_entity
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

      def find_record
        return if params[:id].blank?

        @package = Package.find(params[:id])
      end
    end
  end
end
