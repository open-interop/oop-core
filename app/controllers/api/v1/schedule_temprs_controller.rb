# frozen_string_literal: true

module Api
  module V1
    class ScheduleTemprsController < ApplicationController
      before_action :find_schedule, except: %i[index]
      before_action :find_tempr, except: %i[index]
      before_action :find_schedule_tempr

      # GET /api/v1/schedules_temprs
      def index
        @schedule_temprs =
          ScheduleTemprFilter.records(
            params
          )

        render json:
          ScheduleTemprPresenter.collection(
            @schedule_temprs,
            params[:page]
          ), status: :ok
      end

      # POST /api/v1/schedules_temprs?schedule_id=:schedule_id&tempr_id=:tempr_id
      def create
        @schedule_tempr =
          ScheduleTempr.new(
            schedule_id: @schedule.id,
            tempr_id: @tempr.id
          )

        if @schedule_tempr.save
          render json: @schedule_tempr.to_json(only: %i[id schedule_id tempr_id]), status: :created
        else
          render json: @schedule_tempr.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/schedules_temprs/:id
      # Must provide ?schedule_id and ?tempr_id
      def destroy
        if @schedule_tempr.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      private

      def find_schedule
        @schedule = current_account.schedules.find(params[:schedule_id])
      end

      def find_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])
      end

      def find_schedule_tempr
        return if params[:id].blank?

        @schedule_tempr =
          @schedule.schedule_temprs
                 .where(tempr_id: @tempr.id)
                 .find(params[:id])
      end
    end
  end
end
