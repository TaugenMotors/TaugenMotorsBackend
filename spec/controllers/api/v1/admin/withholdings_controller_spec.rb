require 'rails_helper'

RSpec.describe Api::V1::Admin::WithholdingsController, type: :controller do

  let!(:withholding) { create(:withholding) }
  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive withholdings list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive withholdings list' do
      sign_in_as(owner)
      get :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive withholdings list' do
      sign_in_as(user)
      get :index
      expect(response).to have_http_status(403)
    end

    it 'verify query args' do
      sign_in_as(admin)
      get :index, params: { page: "2", perPage: "2" }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:withholding_params) {
      {
        name: Faker::Commerce.product_name,
        percentage: Faker::Number.decimal(2, 1),
        status: 'disable',
        withholding_type: 'IVA',
        description: Faker::Commerce.department
      }
    }

    it 'returns http success' do
      sign_in_as(admin)
      post :create, params: withholding_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'name', 'percentage', 'withholding_type', 'description', 'status']
    end

    it 'do not allow users to create withholdings with the same name' do
      sign_in_as(admin)
      post :create, params: withholding_params.merge(name: "withholding name")
      expect(response).to be_successful
      post :create, params: withholding_params.merge(name: "withholding name")
      expect(response).to have_http_status(422)
    end

    it 'creates a new withholding' do
      expect do
        sign_in_as(admin)
        post :create, params: withholding_params
      end.to change(Withholding, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      sign_in_as(admin)
      post :create, params: withholding_params.merge(name: nil)
      expect(response).to have_http_status(422)
      post :create, params: withholding_params.merge(percentage: nil)
      expect(response).to have_http_status(422)
      post :create, params: withholding_params.merge(withholding_type: nil)
      expect(response).to have_http_status(422)
      post :create, params: withholding_params.merge(status: nil)
      expect(response).to have_http_status(422)
      post :create, params: withholding_params.merge(status: 'bad status')
      expect(response).to have_http_status(422)
    end

    it 'does not allow regular user to create an withholding' do
      sign_in_as(user)
      post :create, params: withholding_params
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get an withholding' do
      sign_in_as(admin)
      get :show, params: { id: withholding.id }
      expect(response).to be_successful
    end

    it 'allows owner to get an withholding' do
      sign_in_as(owner)
      get :show, params: { id: withholding.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get an withholding' do
      sign_in_as(user)
      get :show, params: { id: withholding.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update an withholding' do
      sign_in_as(admin)
      patch :update, params: { id: withholding.id, withholding: { name: 'New Name' } }
      expect(response).to be_successful
      expect(withholding.reload.name).to eq 'New Name'
    end

    it 'does not allow owner to update an withholding' do
      sign_in_as(owner)
      patch :update, params: { id: withholding.id, withholding: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow regular user to update an withholding' do
      sign_in_as(user)
      patch :update, params: { id: withholding.id, withholding: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete an withholding' do
      sign_in_as(owner)
      delete :destroy, params: { id: withholding.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow regular user to delete an withholding' do
      sign_in_as(user)
      delete :destroy, params: { id: withholding.id }
      expect(response).to have_http_status(403)
    end

    it 'allows admin to delete an withholding' do
      sign_in_as(admin)
      delete :destroy, params: { id: withholding.id }
      expect(response).to be_successful
    end
  end
end