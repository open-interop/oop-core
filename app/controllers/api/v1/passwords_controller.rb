# frozen_string_literal: true

module Api
  module V1
    # API endpoint to aid the user in resetting the password
    class PasswordsController < ApplicationController
      def reset
        render nothing: true, status: 200
      end
    end
  end
end
