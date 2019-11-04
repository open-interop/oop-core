require 'rails_helper'

RSpec.describe Site, type: :model do
  let(:site) { FactoryBot.create(:site, name: 'Test Site') }
  let(:site2) { FactoryBot.create(:site, name: 'Test Site 2') }
  let!(:child_site) do
    FactoryBot.create(:site, name: 'Test Child Site', site: site)
  end

  describe '#generate_full_name' do
    context 'with a parent' do
      it { expect(site.full_name).to eq('Test Site') }
      it { expect(child_site.full_name).to eq('Test Site > Test Child Site') }
    end

    context 'when the parent changes' do
      before do
        child_site.site = site2
        child_site.save
      end

      it { expect(child_site.full_name).to eq('Test Site 2 > Test Child Site') }
    end

    context 'when its name changes' do
      before do
        child_site.name = 'Test Child Site with a new name'
        child_site.save
      end

      it do
        expect(child_site.full_name).to(
          eq('Test Site > Test Child Site with a new name')
        )
      end
    end

    context 'when its parent\'s name changes' do
      before do
        site.reload
        site.name = 'Test Site with a new name'
        site.save
      end

      it { expect(site.full_name).to eq('Test Site with a new name') }
      it do
        child_site.reload
        expect(child_site.full_name).to(
          eq('Test Site with a new name > Test Child Site')
        )
      end
    end
  end
end
