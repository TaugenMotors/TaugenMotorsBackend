require 'rails_helper'

RSpec.describe Api::V1::Admin::CategoriesController, type: :controller do

  let!(:category) { create(:category) }
  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive categories list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive categories list' do
      sign_in_as(owner)
      get :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive categories list' do
      sign_in_as(user)
      get :index
      expect(response).to have_http_status(403)
    end

    it 'verify query args' do
      sign_in_as(admin)
      get :index, params: { page: "2", perPage: "2", search: "a" }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:category_params) {
      {
        name: Faker::Commerce.product_name,
        description: Faker::Commerce.department
      }
    }

    it 'returns http success' do
      sign_in_as(admin)
      post :create, params: category_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'name', 'description']
    end

    it 'do not allow users to create categories with the same name' do
      sign_in_as(admin)
      post :create, params: category_params.merge(name: "category name")
      expect(response).to be_successful
      post :create, params: category_params.merge(name: "category name")
      expect(response).to have_http_status(422)
    end

    it 'creates a new category' do
      expect do
        sign_in_as(admin)
        post :create, params: category_params
      end.to change(Category, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      sign_in_as(admin)
      post :create, params: category_params.merge(name: nil)
      expect(response).to have_http_status(422)
      post :create, params: category_params.merge(description: nil)
      expect(response).to have_http_status(422)
    end

    it 'does not allow regular user to create an category' do
      sign_in_as(user)
      post :create, params: category_params
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get an category' do
      sign_in_as(admin)
      get :show, params: { id: category.id }
      expect(response).to be_successful
    end

    it 'allows owner to get an category' do
      sign_in_as(owner)
      get :show, params: { id: category.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get an category' do
      sign_in_as(user)
      get :show, params: { id: category.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update an category' do
      sign_in_as(admin)
      patch :update, params: { id: category.id, category: { name: 'New Name' } }
      expect(response).to be_successful
      expect(category.reload.name).to eq 'New Name'
    end

    it 'raise an error with bad params' do
      sign_in_as(admin)
      patch :update, params: { id: category.id, category: { name: nil } }
      expect(response).to have_http_status(422)
      expect(response_json.keys).to eq ['error']
    end

    it 'does not allow owner to update an category' do
      sign_in_as(owner)
      patch :update, params: { id: category.id, category: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow regular user to update an category' do
      sign_in_as(user)
      patch :update, params: { id: category.id, category: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete an category' do
      sign_in_as(owner)
      delete :destroy, params: { id: category.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow regular user to delete an category' do
      sign_in_as(user)
      delete :destroy, params: { id: category.id }
      expect(response).to have_http_status(403)
    end

    it 'allows admin to delete an category' do
      sign_in_as(admin)
      delete :destroy, params: { id: category.id }
      expect(response).to be_successful
    end
  end
end
