require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when created' do
    it do
      expect { FactoryBot.create(:user) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
