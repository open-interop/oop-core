# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApplicationController
      # GET /api/v1/dashboards/transmissions?device_id&group
      def transmissions
        @transmissions =
          TransmissionFilter.records(
            params,
            scope: current_account
          )

        group_param = params[:group]

        if !TransmissionFilter.sortable_fields
                              .include?(params[:group])
          group = 'status'
          group_param = group
        elsif TransmissionFilter.filterable_fields[:datetime]
                                .include?(params[:group])
          group = "DATE(#{params[:group]})"
        else
          group = params[:group]
        end

        @transmissions =
          @transmissions.group(group).count

        render json: { transmissions: @transmissions, group: group_param }
      end
    end
  end
end
