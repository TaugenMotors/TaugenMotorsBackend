class Api::V1::Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/users' do
    operation :get do
      key :description, 'get users'
      key :operationId, 'getUsers'
      key :produces, [ 'application/json' ]
      key :tags, [ 'users' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :role
      parameter :search
      response 200 do
        key :description, 'Users'
        schema do
          key :'$ref', :Users
        end
      end
      response 422 do
        key :description, 'Unprocessable Entity'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # GET /admin/users
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    queryRole = pagination_params[:role] || nil
    querySearch = pagination_params[:search] || nil
    # Seach all Users
    @users = User.all.order(:id)
    # Filter by role
    if queryRole
      @users = @users.where(role: queryRole)
    end
    # Seah string in name
    if querySearch
      @users = @users.where('name ~* :pat', :pat => querySearch)
    end
    # Define total pages with this perPage
    totalItems = @users.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @users = @users.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @users
  end

  # Swagger
  swagger_path '/admin/users/{id}' do
    parameter :pathId
    operation :get do
      key :description, 'show user'
      key :operationId, 'showUser'
      key :produces, [ 'application/json' ]
      key :tags, [ 'users' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Users'
        schema do
          key :'$ref', :User
        end
      end
      response 404 do
        key :description, 'Not Found'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # GET /admin/users/:id
  def show
    render json: @user
  end

  # Swagger
  swagger_path '/admin/users/{id}' do
    parameter :pathId
    operation :patch do
      key :description, 'Update user role'
      key :operationId, 'updateUser'
      key :produces, [ 'application/json' ]
      key :tags, [ 'users' ]
      parameter :csrfToken
      parameter do
        key :name, :updateUser
        key :in, :body
        key :description, 'User to update'
        key :required, true
        schema do
          key :'$ref', :UpdateUser
        end
      end
      response 200 do
        key :description, 'User to update'
        schema do
          key :'$ref', :User
        end
      end
      response 404 do
        key :description, 'Not Found'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response 400 do
        key :description, 'Bad Request'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # PATHC /admin/users/:id
  def update
    if current_user.id != @user.id
      @user.update!(user_params)
      JWTSessions::Session.new(namespace: "user_#{@user.id}").flush_namespaced_access_tokens
      render json: @user
    else
      render json: { error: 'Admin cannot modify their own role' }, status: :bad_request
    end
  end

  # Swagger
  swagger_path '/admin/users/{id}' do
    parameter :pathId
    operation :delete do
      key :description, 'Delete user'
      key :operationId, 'deleteUser'
      key :produces, [ 'application/json' ]
      key :tags, [ 'users' ]
      parameter :csrfToken
      response 200 do
        key :description, :ok
      end
      response 404 do
        key :description, 'Not Found'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response 400 do
        key :description, 'Forbidden'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # DELETE /admin/users/:id
  def destroy
    if current_user.id != @user.id
      @user.destroy
      JWTSessions::Session.new(namespace: "user_#{@user.id}").flush_namespaced_access_tokens
      render json: :ok
    else
      render json: { error: 'The user can not delete himself' }, status: :bad_request
    end
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end
  
  private

  def allowed_aud
    ( ['destroy', 'update'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:role)
  end
end
