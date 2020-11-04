# frozen_string_literal: true

module Api
  module V1
    class SchedulesController < ApplicationController
      before_action :find_schedule

      # GET /api/v1/schedules
      def index
        @schedules = ScheduleFilter.records(params, scope: current_account)

        render json:
          SchedulePresenter.collection(@schedules, params[:page]), status: :ok
      end

      # GET /api/v1/schedules/:id
      def show
        render json: @schedule
      end

      # POST /api/v1/schedules
      def create
        @schedule = current_account.schedules.build(schedule_params)

        if @schedule.save
          render json: @schedule, status: :created
        else
          render json: @schedule.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/schedules/:id
      def update
        if @schedule.update(schedule_params)
          render json: @schedule
        else
          render json: @schedule.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/schedules/:id
      def destroy
        if @schedule.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # POST /api/v1/schedules/:id/assign_tempr
      def assign_tempr
        @tempr = current_account.temprs.find(params[:tempr_id])

        @schedule_tempr = @schedule.schedule_temprs.create(tempr: @tempr)

        render json: @schedule_tempr, status: :created
      end

      # GET /api/v1/schedules/:id/history
      def history
        @audits =
          AuditableFilter.records(params, scope: current_account)

        render json:
          AuditablePresenter.collection(@audits, params[:page]), status: :ok
      end

      private

      def find_schedule
        return if params[:id].blank?

        @schedule = current_account.schedules.find(params[:id])
      end

      def schedule_params
        params.require(:schedule).permit(
          :name,
          :active,
          :minute,
          :hour,
          :day_of_week,
          :day_of_month,
          :month_of_year,
          :year,
          :queue_messages
        )
      end
    end
  end
end
