# frozen_string_literal: true

class UserPresenter < BasePresenter
  attributes :id, :email, :first_name, :last_name, :description, :job_title, :dob, :created_at, :updated_at
end
