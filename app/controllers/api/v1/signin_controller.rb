class Api::V1::SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  # Swagger
  swagger_path '/signin' do
    operation :post do
      key :description, 'Log in user'
      key :operationId, 'createSession'
      key :tags, [
        'session'
      ]
      parameter do
        key :name, :userAuth
        key :in, :body
        key :description, 'User Auth'
        key :required, true
        schema do
          key :'$ref', :AuthUser
        end
      end
      response 200 do
        key :description, 'Session created'
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
  # POST /api/1/signin
  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload  = { user_id: user.id, aud: [user.role] }
      session = JWTSessions::Session.new(payload: payload,
                                         refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  # Swagger
  swagger_path '/signin' do
    operation :delete do
      key :description, 'Log out user (delete session)'
      key :operationId, 'deleteSession'
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
        key :description, :ok
      end
      response 401 do
        key :description, 'Unauthorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # DELETE /api/v1/signin
  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

end
