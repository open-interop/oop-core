# frozen_string_literal: true

class ServicesController < ApplicationController
  skip_before_action :login_required
  before_action :authenticate_as_microservice

  private

  def authenticate_as_microservice
    return if request.headers['X-Core-Token'] == ENV['OOP_CORE_AUTH_TOKEN']

    access_denied
  end
end
