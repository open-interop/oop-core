# frozen_string_literal: true

module Api
  module V1
    # API endpoint to aid the user in resetting the password
    class PasswordsController < ApplicationController
      skip_before_action :login_required

      def create
        if (user = current_account.users.find_by(email: params[:email]))
          user.generate_password_reset_token!
          user.send_reset_password_email
        end

        render nothing: true, status: :ok
      end

      def reset
        user =
          current_account.users
                         .where.not(password_reset_token: nil)
                         .find_by(password_reset_token: params[:token])

        if user&.valid_password_reset_token?
          unless user.reset_password!(
              params[:password],
              params[:password_confirmation]
            )

            render json: user.errors, status: :unprocessable_entity
            return
          end
        end

        render nothing: true, status: :ok
      end
    end
  end
end
