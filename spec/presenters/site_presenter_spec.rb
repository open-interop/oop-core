require 'rails_helper'

RSpec.describe SitePresenter do
  describe '::sidebar' do
    let!(:account) { FactoryBot.create(:account) }
    let!(:site) { FactoryBot.create(:site, name: 'A site', account: account) }
    let!(:device_group) { FactoryBot.create(:device_group, name: 'A device group', account: account) }
    let!(:device) { FactoryBot.create(:device, name: 'A device', device_group: device_group) }

    context 'single site with no children' do
      let(:sidebar) do
        described_class.sidebar(account, site)
      end

      it do
        expect(sidebar).to(
          eq(
            sites:
              [
                {
                  id: site.id,
                  name: site.name,
                  device_groups:
                    [
                      {
                        id: device_group.id,
                        name: device_group.name,
                        devices:
                          [
                            {
                              id: device.id,
                              name: device.name
                            }
                          ]
                      }
                    ]
                }
              ]
          )
        )
      end
    end

    context 'all sites' do
      let!(:site_two) do
        FactoryBot.create(:site, name: 'B site', account: account)
      end

      let!(:device_group_two) do
        FactoryBot.create(:device_group, name: 'B device group', account: account)
      end

      let!(:device_two) do
        FactoryBot.create(:device, name: 'B device', site: site_two, device_group: device_group_two, authentication_path: '/a')
      end

      let(:sidebar) do
        described_class.sidebar(account)
      end

      it do
        expect(sidebar).to(
          eq(
            sites:
              [
                {
                  id: site.id,
                  name: site.name,
                  device_groups:
                    [
                      {
                        id: device_group.id,
                        name: device_group.name,
                        devices:
                          [
                            {
                              id: device.id,
                              name: device.name
                            }
                          ]
                      },
                      {
                        id: device_group_two.id,
                        name: device_group_two.name,
                        devices: []
                      }
                    ]
                },
                {
                  id: site_two.id,
                  name: site_two.name,
                  device_groups:
                    [
                      {
                        id: device_group.id,
                        name: device_group.name,
                        devices: []
                      },
                      {
                        id: device_group_two.id,
                        name: device_group_two.name,
                        devices:
                          [
                            {
                              id: device_two.id,
                              name: device_two.name
                            }
                          ]
                      }
                    ]
                }
              ]
          )
        )
      end
    end
  end
end
