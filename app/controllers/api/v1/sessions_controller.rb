# frozen_string_literal: true

# API endpoint to log the user in
module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :login_required, only: :create

      # POST /auth/login
      def create
        @current_user =
          User.authenticate_with_password(current_account, params[:email], params[:password])

        if logged_in?
          render json: @current_user.authenticated_token, status: :ok
        else
          access_denied
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
