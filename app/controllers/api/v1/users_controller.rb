class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!

  # Swagger
  swagger_path '/me' do
    operation :get do
      key :description, 'Get current user'
      key :operationId, 'getCurrentUser'
      key :tags, [
        'session'
      ]
      parameter do
        key :name, 'X-CSRF-TOKEN'
        key :in, :header
        key :description, 'Session to delete'
        key :required, true
      end
      response 200 do
        key :description, 'Current User'
        schema do
          key :'$ref', :User
        end
      end
      response 401 do
        key :description, 'Unauthorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # GET /api/v1/me
  def me
    render json: current_user
  end
end
