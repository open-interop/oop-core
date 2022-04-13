# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApplicationController
      # GET /api/v1/dashboards/transmissions?device_id&group
      def transmissions
        @transmissions =
          TransmissionFilter.records(
            params,
            { scope: current_account, unsorted: true }
          )

        group_param = params[:group]

        if !TransmissionFilter.sortable_fields
                              .include?(params[:group])
          group = 'status'
          group_param = group
        elsif TransmissionFilter.filterable_fields[:datetime]
                                .include?(params[:group])
          group = "DATE(transmissions.#{params[:group]})"
        else
          group = "transmissions.#{params[:group]}"
        end

        @transmissions =
          @transmissions.group(group).count

        render json: { transmissions: @transmissions, group: group_param }
      end

      # GET /api/v1/dashboards/messages
      def messages
        @messages =
          MessageFilter.records(
            params,
            { scope: current_account, unsorted: true }
          )

        group_param = params[:group]

        if !MessageFilter.sortable_fields
                         .include?(params[:group])
          group = 'transmission_count'
          group_param = group
        elsif MessageFilter.filterable_fields[:datetime]
                           .include?(params[:group])
          group = "DATE(messages.#{params[:group]})"
        else
          group = "messages.#{params[:group]}"
        end

        @messages =
          @messages.group(group).count

        render json: { messages: @messages, group: group_param }
      end
    end
  end
end
