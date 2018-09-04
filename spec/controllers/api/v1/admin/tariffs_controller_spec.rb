require 'rails_helper'

RSpec.describe Api::V1::Admin::TariffsController, type: :controller do

  let!(:tariff) { create(:tariff) }
  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive tariff list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive tariff list' do
      sign_in_as(owner)
      get :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive tariff list' do
      sign_in_as(user)
      get :index
      expect(response).to have_http_status(403)
    end

    it 'verify query args' do
      sign_in_as(admin)
      get :index, params: { page: "2", perPage: "2", shift: "1st turn", search: "a" }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:tariff_params) {
      {
        driver_name: Faker::Name.name,
        vehicle_plate: 'QFC-426',
        shift_name: '1st turn',
        shift_date: Faker::Date.forward(2),
        owner_tariff: Faker::Number.decimal(5, 2),
        paid: Faker::Number.decimal(4, 2),
        debt: Faker::Number.decimal(4, 2),
        comments: Faker::MostInterestingManInTheWorld.quote,
        status: 'pendiente'
      }
    }

    it 'returns http success' do
      sign_in_as(admin)
      post :create, params: tariff_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'driver_name', 'vehicle_plate', 'shift_name', 'shift_date', 'owner_tariff', 'paid', 'debt', 'comments', 'status']
    end

    it 'creates a new tariff' do
      expect do
        sign_in_as(admin)
        post :create, params: tariff_params
      end.to change(Tariff, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      sign_in_as(admin)
      post :create, params: tariff_params.merge(driver_name: nil)
      expect(response).to have_http_status(422)
      post :create, params: tariff_params.merge(vehicle_plate: nil)
      expect(response).to have_http_status(422)
      post :create, params: tariff_params.merge(owner_tariff: nil)
      expect(response).to have_http_status(422)
      post :create, params: tariff_params.merge(paid: nil)
      expect(response).to have_http_status(422)
      post :create, params: tariff_params.merge(debt: nil)
      expect(response).to have_http_status(422)
      post :create, params: tariff_params.merge(status: 'bad status')
      expect(response).to have_http_status(422)
    end

    it 'does not allow regular user to create an tariff' do
      sign_in_as(user)
      post :create, params: tariff_params
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get an tariff' do
      sign_in_as(admin)
      get :show, params: { id: tariff.id }
      expect(response).to be_successful
    end

    it 'allows owner to get an tariff' do
      sign_in_as(owner)
      get :show, params: { id: tariff.id }
      expect(response).to be_successful
    end

    it 'does not allow regular tariff to get an tariff' do
      sign_in_as(user)
      get :show, params: { id: tariff.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update an tariff' do
      sign_in_as(admin)
      patch :update, params: { id: tariff.id, tariff: { comments: 'some comment' } }
      expect(response).to be_successful
      expect(tariff.reload.comments).to eq 'some comment'
    end

    it 'does not allow owner to update an tariff' do
      sign_in_as(owner)
      patch :update, params: { id: tariff.id, tariff: { comments: 'some comment' } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow tariff to update an tariff' do
      sign_in_as(user)
      patch :update, params: { id: tariff.id, tariff: { comments: 'some comment' } }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete an tariff' do
      sign_in_as(owner)
      delete :destroy, params: { id: tariff.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow tariff to delete an tariff' do
      sign_in_as(user)
      delete :destroy, params: { id: tariff.id }
      expect(response).to have_http_status(403)
    end

    it 'allows admin to delete an tariff' do
      sign_in_as(admin)
      delete :destroy, params: { id: tariff.id }
      expect(response).to be_successful
    end
  end
end