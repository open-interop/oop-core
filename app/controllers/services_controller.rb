# frozen_string_literal: true

class ServicesController < ApplicationController
  skip_before_action :login_required
  before_action :authenticate_as_microservice

  private

  def authenticate_as_microservice
    return if Rails.configuration.oop[:services_token].present? &&
              request.headers['X-Core-Token'] == Rails.configuration.oop[:services_token]

    access_denied
  end
end
