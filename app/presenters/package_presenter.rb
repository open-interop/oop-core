# frozen_string_literal: true

class PackagePresenter < BasePresenter
  attributes :id, :name, :device_groups_limit, :devices_limit, 
                 :layers_limit, :schedules_limit, :sites_limit, 
                     :temprs_limit, :users_limit, :created_at, :updated_at
end

