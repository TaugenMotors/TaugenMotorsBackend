require 'rails_helper'

RSpec.describe Api::V1::SignupController, type: :controller do

  describe 'POST #create' do
    let(:user_params) {
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        telephone: Faker::PhoneNumber.cell_phone
      }
    }

    it 'returns http success' do
      expect(UserMailer).to receive(:reset_password).once.and_return(double(deliver_now: true))
      post :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'email', 'role', 'name', 'telephone']
    end

    it 'creates a new user' do
      expect do
        post :create, params: user_params
      end.to change(User, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      expect(UserMailer).to_not receive(:reset_password)
      post :create, params: user_params.merge(name: nil)
      expect(response).to have_http_status(422)
    end

    it 'raise unprocessable entity error ' do
      expect(UserMailer).to_not receive(:reset_password)
      post :create, params: user_params.merge(role: 'badrole')
      expect(response).to have_http_status(422)
    end

  end
end
