require 'rails_helper'

RSpec.describe Api::V1::Admin::ItemsController, type: :controller do

  let!(:item) { create(:item) }
  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive items list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive items list' do
      sign_in_as(owner)
      get :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive items list' do
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
    let(:item_params) {
      {
        name: Faker::Commerce.product_name,
        reference: Faker::Number.number(10),
        price: Faker::Number.decimal(5, 3),
        tax: Faker::Number.decimal(2, 1),
        description: Faker::Commerce.department,
        provider: Faker::Company.name,
        status: 'disable'
      }
    }

    it 'returns http success' do
      sign_in_as(admin)
      post :create, params: item_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'name', 'reference', 'price', 'tax', 'description', 'provider', 'status']
    end

    it 'do not allow users to create items with the same reference' do
      sign_in_as(admin)
      post :create, params: item_params.merge(reference: "item reference")
      expect(response).to be_successful
      post :create, params: item_params.merge(reference: "item reference")
      expect(response).to have_http_status(422)
    end

    it 'creates a new item' do
      expect do
        sign_in_as(admin)
        post :create, params: item_params
      end.to change(Item, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      sign_in_as(admin)
      post :create, params: item_params.merge(name: nil)
      expect(response).to have_http_status(422)
      post :create, params: item_params.merge(price: nil)
      expect(response).to have_http_status(422)
      post :create, params: item_params.merge(reference: nil)
      expect(response).to have_http_status(422)
      post :create, params: item_params.merge(status: nil)
      expect(response).to have_http_status(422)
      post :create, params: item_params.merge(status: 'bad status')
      expect(response).to have_http_status(422)
    end

    it 'does not allow regular user to create an item' do
      sign_in_as(user)
      post :create, params: item_params
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get an item' do
      sign_in_as(admin)
      get :show, params: { id: item.id }
      expect(response).to be_successful
    end

    it 'allows owner to get an item' do
      sign_in_as(owner)
      get :show, params: { id: item.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get an item' do
      sign_in_as(user)
      get :show, params: { id: item.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update an item' do
      sign_in_as(admin)
      patch :update, params: { id: item.id, item: { name: 'New Name' } }
      expect(response).to be_successful
      expect(item.reload.name).to eq 'New Name'
    end

    it 'does not allow owner to update an item' do
      sign_in_as(owner)
      patch :update, params: { id: item.id, item: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow regular user to update an item' do
      sign_in_as(user)
      patch :update, params: { id: item.id, item: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete an item' do
      sign_in_as(owner)
      delete :destroy, params: { id: item.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow regular user to delete an item' do
      sign_in_as(user)
      delete :destroy, params: { id: item.id }
      expect(response).to have_http_status(403)
    end

    it 'allows admin to delete an item' do
      sign_in_as(admin)
      delete :destroy, params: { id: item.id }
      expect(response).to be_successful
    end
  end
end
