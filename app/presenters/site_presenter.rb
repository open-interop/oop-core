# frozen_string_literal: true

class SitePresenter < BasePresenter
  attributes :id, :account_id, :site_id, :name, :full_name, :description,
             :address, :city, :state, :zip_code, :country, :region,
             :latitude, :longitude, :time_zone, :external_uuids,
             :created_at, :updated_at

  def self.sidebar_sites(account, site)
    if site
      [site] + site.sites
    else
      account.sites
    end
  end

  def self.sidebar(account, filtered_site = nil)
    sites = sidebar_sites(account, filtered_site)

    {
      sites:
        sites.map do |site|
          {
            id: site.id,
            name: site.name,
            device_groups:
              account.device_groups.map do |device_group|
                {
                  id: device_group.id,
                  name: device_group.name,
                  devices:
                    device_group.devices.where(site_id: site.id)
                           .map do |device|
                      {
                        id: device.id,
                        name: device.name
                      }
                    end
                }
              end
          }
        end
    }
  end
end
