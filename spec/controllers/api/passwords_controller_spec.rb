require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :controller do
  describe 'POST #reset' do
    context 'returns a success response' do
      before do
        post(:reset, params: { email: 'example@example.com' })
      end

      it { expect(response).to be_successful }
    end
  end
end
