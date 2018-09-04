class Api::V1::Admin::WithholdingsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_withholding, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/withholdings' do
    operation :get do
      key :description, 'get withholdings'
      key :operationId, 'getWithholdings'
      key :produces, [ 'application/json' ]
      key :tags, [ 'withholdings' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :search
      response 200 do
        key :description, 'Withholdings'
        schema do
          key :'$ref', :Withholdings
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
  # GET /admin/withholdings
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    # Seach all Withholdings
    @withholdings = Withholding.all.order(:id)
    # Define total pages with this perPage
    totalItems = @withholdings.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @withholdings = @withholdings.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @withholdings
  end

  # Swagger
  swagger_path '/admin/withholdings' do
    operation :post do
      key :description, 'Creates a new withholding. Duplicate names are not allowed'
      key :operationId, 'addWithholding'
      key :produces, [ 'application/json' ]
      key :tags, [ 'withholdings' ]
      parameter do
        key :name, :withholding
        key :in, :body
        key :description, 'Withholding to add'
        key :required, true
        schema do
          key :'$ref', :CreateWithholding
        end
      end
      response 200 do
        key :description, 'Created Withholding'
        schema do
          key :'$ref', :Withholding
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
  # POST /admin/withholdings
  def create
    begin
      withholding = Withholding.new(create_withholding_params)
      if withholding.save
        render json: withholding
      else
        render json: { error: withholding.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/withholdings/{id}' do
    parameter :pathId
    operation :get do
      key :description, 'show withholding'
      key :operationId, 'showWithholding'
      key :produces, [ 'application/json' ]
      key :tags, [ 'withholdings' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Withholdings'
        schema do
          key :'$ref', :Withholding
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
  # GET /admin/withholdings/:id
  def show
    render json: @withholding
  end

  # Swagger
  swagger_path '/admin/withholdings/{id}' do
    parameter :pathId
    operation :patch do
      key :description, 'Update withholding'
      key :operationId, 'updateWithholding'
      key :produces, [ 'application/json' ]
      key :tags, [ 'withholdings' ]
      parameter :csrfToken
      parameter do
        key :name, :updateWithholding
        key :in, :body
        key :description, 'Withholding to update'
        key :required, true
        schema do
          key :'$ref', :UpdateWithholding
        end
      end
      response 200 do
        key :description, 'Withholding to update'
        schema do
          key :'$ref', :Withholding
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
  # PATHC /admin/withholdings/:id
  def update
    @withholding.update!(withholding_params)
    render json: @withholding
  end

  # Swagger
  swagger_path '/admin/withholdings/{id}' do
    parameter :pathId
    operation :delete do
      key :description, 'Delete withholding'
      key :operationId, 'deleteWithholding'
      key :produces, [ 'application/json' ]
      key :tags, [ 'withholdings' ]
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
  # DELETE /admin/withholdings/:id
  def destroy
    @withholding.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_withholding
    @withholding = Withholding.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def withholding_params
    params.require(:withholding).permit(:name, :percentage, :description, :withholding_type, :status)
  end

  def create_withholding_params
    params.permit(:name, :percentage, :description, :withholding_type, :status)
  end
end
