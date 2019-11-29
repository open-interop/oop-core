# frozen_string_literal: true

class SitePresenter < BasePresenter
  attributes :id, :account_id, :site_id, :name, :full_name, :description,
             :address, :city, :state, :zip_code, :country, :region,
             :latitude, :longitude, :time_zone, :external_uuids,
             :created_at, :updated_at
end
