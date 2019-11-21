# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApplicationController
      # GET /api/v1/dashboards/transmissions?device_id&group
      def transmissions
        @device = current_account.devices.find(params[:device_id])

        @transmissions =
          TransmissionFilter.records(
            params,
            scope: @device
          )

        if !TransmissionFilter.sortable_fields.include?(params[:group])
          group = 'status'
        elsif TransmissionFilter.filterable_fields[:datetime].include?(params[:group])
          group = "DATE(#{params[:group]})"
        else
          group = params[:group]
        end

        @transmissions =
          @transmissions.group(group).count

        render json: { transmissions: @transmissions, group: params[:group] }
      end
    end
  end
end
