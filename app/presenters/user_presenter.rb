# frozen_string_literal: true

class UserPresenter < BasePresenter
  attributes :id, :email, :first_name, :last_name, :description, :job_title, :date_of_birth, :created_at, :updated_at
end
