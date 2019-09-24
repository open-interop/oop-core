# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :find_user

      # GET /api/v1/users
      def index
        @users = current_account.users
        render json: @users, status: :ok
      end

      # GET /api/v1/users/:id
      def show
        render json: @user.to_json(only: [:id, :email, :time_zone]), status: :ok
      end

      # POST /api/v1/users
      def create
        @user = current_account.users.build(user_params)

        if @user.save
          render json: @user.to_json(only: [:id, :email, :time_zone]), status: :created
        else
          render json: @user.errors,
                 status: :unprocessable_entity
        end
      end

      # PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: @user.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
      end

      private

      def find_user
        return if params[:id].blank?

        @user = current_account.users.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
      end

      def user_params
        params.fetch(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :time_zone
        )
      end
    end
  end
end
