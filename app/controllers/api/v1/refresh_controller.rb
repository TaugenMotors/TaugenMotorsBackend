class Api::V1::RefreshController < ApplicationController
  before_action :authorize_refresh_by_access_request!

  # Swagger
  swagger_path '/refresh' do
    operation :post do
      key :description, 'Refresh token'
      key :operationId, 'refreshToken'
      key :tags, [
        'session'
      ]
      parameter do
        key :name, 'X-CSRF-TOKEN'
        key :in, :header
        key :description, 'Token to refresh'
        key :required, true
      end
      response 200 do
        key :description, 'csrf token'
        schema do
          key :'$ref', :CsrfTokenModel
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
  # POST /api/v1/refresh
  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload do
      raise JWTSessions::Errors::Unauthorized, 'Malicious activity detected'
    end
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)

    render json: { csrf: tokens[:csrf] }
  end
end
