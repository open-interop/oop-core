# frozen_string_literal: true

# All controllers inherit from this class
class ApplicationController < ActionController::API
  include AccountableController
  include AuthenticationController

  before_action :login_required

  #before_action do
  #  Time.zone = logged_in? ? current_user.time_zone : 'London'
  #end

  def not_found
    render json: { error: 'not_found' }
  end
end
