require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  let(:user) { create(:user) }
  before { sign_in_as(user) }

  describe 'GET #me' do
    # let!(:todo) { create(:todo, user: user) }

    it 'returns a success response' do
      get :me
      expect(response).to be_successful
      expect(response_json).to eq user.as_json(only: [:id, :email, :role])
    end
  end
end