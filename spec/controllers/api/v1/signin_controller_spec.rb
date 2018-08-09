require 'rails_helper'

RSpec.describe Api::V1::SigninController, type: :controller do

  let(:access_cookie) { @tokens[:access] }
  let(:csrf_token) { @tokens[:csrf] }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:password) { 'password' }
    let(:user_params) { { email: user.email, password: password } }

    it 'returns http success' do
      post :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns unauthorized for invalid params' do
      post :create, params: { email: user.email, password: 'incorrect' }
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE #destroy' do
    before do
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      @tokens = session.login
      request.cookies[JWTSessions.access_cookie] = access_cookie
    end
    
    it 'returns http success' do
      request.headers[JWTSessions.csrf_header] = csrf_token
      delete :destroy
      expect(response).to be_successful
    end

    it 'returns unauthorized for invalid params' do
      request.headers[JWTSessions.csrf_header] = 1
      delete :destroy
      expect(response).to have_http_status(401)
    end
  end
end
