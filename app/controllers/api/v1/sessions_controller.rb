# frozen_string_literal: true

module Api
  module V1
    # API endpoint to log the user in
    class SessionsController < ApplicationController
      skip_before_action :login_required, only: :create

      # POST /api/v1/auth/login
      def create
        @current_user =
          User.authenticate_with_password(
            current_account,
            login_params[:email], login_params[:password]
          )

        if logged_in?
          render json: @current_user.authenticated_token, status: :ok
        else
          access_denied
        end
      end

      # GET /api/v1/me
      def me
        render json:
          current_user.to_json(only: %i[id email time_zone created_at updated_at])
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
