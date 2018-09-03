require 'rails_helper'

RSpec.describe Api::V1::Admin::TermsController, type: :controller do

  let!(:term) { create(:term) }
  let!(:user) { create(:user) }
  let!(:owner) { create(:user, role: :owner) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive terms list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response.headers["TOTAL-PAGES"]).to be_present
    end

    it 'allows owner to receive terms list' do
      sign_in_as(owner)
      get :index
      expect(response).to be_successful
    end

    it 'does not allow regular user to receive terms list' do
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
    let(:term_params) {
      {
        name: Faker::Commerce.product_name,
        days: Faker::Number.number(2),
        status: 'disable'
      }
    }

    it 'returns http success' do
      sign_in_as(admin)
      post :create, params: term_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['id', 'name', 'days', 'status']
    end

    it 'do not allow users to create terms with the same name' do
      sign_in_as(admin)
      post :create, params: term_params.merge(name: "term name")
      expect(response).to be_successful
      post :create, params: term_params.merge(name: "term name")
      expect(response).to have_http_status(422)
    end

    it 'creates a new term' do
      expect do
        sign_in_as(admin)
        post :create, params: term_params
      end.to change(Term, :count).by(1)
    end

    it 'raise unprocessable entity error ' do
      sign_in_as(admin)
      post :create, params: term_params.merge(name: nil)
      expect(response).to have_http_status(422)
      post :create, params: term_params.merge(days: nil)
      expect(response).to have_http_status(422)
      post :create, params: term_params.merge(status: nil)
      expect(response).to have_http_status(422)
      post :create, params: term_params.merge(status: 'bad status')
      expect(response).to have_http_status(422)
    end

    it 'does not allow regular user to create an term' do
      sign_in_as(user)
      post :create, params: term_params
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get an term' do
      sign_in_as(admin)
      get :show, params: { id: term.id }
      expect(response).to be_successful
    end

    it 'allows owner to get an term' do
      sign_in_as(owner)
      get :show, params: { id: term.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get an term' do
      sign_in_as(user)
      get :show, params: { id: term.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update an term' do
      sign_in_as(admin)
      patch :update, params: { id: term.id, term: { name: 'New Name' } }
      expect(response).to be_successful
      expect(term.reload.name).to eq 'New Name'
    end

    it 'does not allow owner to update an term' do
      sign_in_as(owner)
      patch :update, params: { id: term.id, term: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow regular user to update an term' do
      sign_in_as(user)
      patch :update, params: { id: term.id, term: { name: 'New Name' } }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow owner to delete an term' do
      sign_in_as(owner)
      delete :destroy, params: { id: term.id }
      expect(response).to have_http_status(403)
    end
    
    it 'does not allow regular user to delete an term' do
      sign_in_as(user)
      delete :destroy, params: { id: term.id }
      expect(response).to have_http_status(403)
    end

    it 'allows admin to delete an term' do
      sign_in_as(admin)
      delete :destroy, params: { id: term.id }
      expect(response).to be_successful
    end
  end
end
