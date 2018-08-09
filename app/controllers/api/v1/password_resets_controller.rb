class Api::V1::PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  KEYS = [:password, :password_confirmation].freeze

  # Swagger
  swagger_path '/password_resets' do
    operation :post do
      key :description, 'Create new token for password reset'
      key :operationId, 'resetPassword'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'session'
      ]
      parameter do
        key :name, :email
        key :in, :body
        key :description, 'User email'
        key :required, true
        schema do
          key :'$ref', :SendResetPassword
        end
      end
      response 200 do
        key :description, :ok
      end
    end
  end
  # POST /api/v1/password_resets
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_token!
      UserMailer.reset_password(user).deliver_now
    end
    # even if a user is not found we should return a successful 
    # response anyway so an attacker will not be able to check 
    # whether certain email addresses are registered in the system
    render json: :ok
  end

 # Swagger
  swagger_path '/password_resets/{token}' do
    parameter do
      key :name, :token
      key :in, :path
      key :description, 'Reset token'
      key :required, true
      key :type, :string
    end
    operation :get do
      key :description, 'Check reset token'
      key :operationId, 'checkResetToken'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'session'
      ]
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
  # GET /api/v1/password_resets/:token
  def edit
    render json: :ok
  end

  # Swagger
  swagger_path '/password_resets/{token}' do
    parameter do
      key :name, :token
      key :in, :path
      key :description, 'Reset token'
      key :required, true
      key :type, :string
    end
    operation :patch do
      key :description, 'Reset User password'
      key :operationId, 'resetPassword'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'session'
      ]
      parameter do
        key :name, :password_params
        key :in, :body
        key :description, 'Reset password'
        key :required, true
        schema do
          key :'$ref', :ResetPassword
        end
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
  # PATCH /api/v1/password_resets/:token
  def update
    @user.update!(password_params)
    @user.clear_password_token!
    render json: :ok
  end

  private

  def password_params
    params.tap { |p| p.require(KEYS) }.permit(*KEYS)
  end

  def set_user
    @user = User.find_by(reset_password_token: params[:token])
    raise ResetPasswordError unless @user&.reset_password_token_expires_at && @user.reset_password_token_expires_at > Time.now
  end
end
