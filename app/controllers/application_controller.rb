# frozen_string_literal: true

# All controllers inherit from this class
class ApplicationController < ActionController::API
  include AccountableController
  include AuthenticationController

  before_action :login_required

  include ErrorsController

  before_action do
    params[:page] ||= {}
  end
end
