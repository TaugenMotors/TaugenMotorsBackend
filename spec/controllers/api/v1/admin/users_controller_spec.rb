require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :controller do

  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'POST #index' do
    it 'allows admin to receive users list' do
      sign_in_as(admin)
      post :index, params: { page: "2", perPage: "2", role: "manager", search: "a" }
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive users list' do
      sign_in_as(owner)
      post :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive users list' do
      sign_in_as(user)
      post :index
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get a user' do
      sign_in_as(admin)
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'allows owner to get a user' do
      sign_in_as(owner)
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get a user' do
      sign_in_as(user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update a user' do
      sign_in_as(admin)
      patch :update, params: { id: user.id, user: { role: :owner } }
      expect(response).to be_successful
      expect(user.reload.role).to eq 'owner'
    end

    it 'does not allow owner to update a user' do
      sign_in_as(owner)
      patch :update, params: { id: user.id, user: { role: :owner } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow user to update a user' do
      sign_in_as(user)
      patch :update, params: { id: user.id, user: { role: :owner } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow admin to update their own role' do
      sign_in_as(admin)
      patch :update, params: { id: admin.id, user: { role: :owner } }
      expect(response).to have_http_status(400)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete a user' do
      sign_in_as(owner)
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow user to delete a user' do
      sign_in_as(user)
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow admin to delete their own user' do
      sign_in_as(admin)
      delete :destroy, params: { id: admin.id }
      expect(response).to have_http_status(400)
    end

    it 'allows admin to delete a user' do
      sign_in_as(admin)
      delete :destroy, params: { id: user.id }
      expect(response).to be_successful
    end
  end
end