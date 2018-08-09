require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  let(:user) { create(:user) }
  before { sign_in_as(user) }

  describe 'GET #me' do
    it 'returns a success response' do
      get :me
      expect(response).to be_successful
      expect(response_json["id"]).to eq user["id"]
    end
  end
end
