# frozen_string_literal: true

module ManagementApi
  module V1
    # Parent REST Management API controller
    class BaseController < ApplicationController
    	before_action :super_user_required
    end
  end
end
