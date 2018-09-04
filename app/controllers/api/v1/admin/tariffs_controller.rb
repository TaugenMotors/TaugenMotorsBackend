class Api::V1::Admin::TariffsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_tariff, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/tariffs' do
    operation :get do
      key :description, 'get tariffs'
      key :operationId, 'getTariffs'
      key :produces, [ 'application/json' ]
      key :tags, [ 'tariffs' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :shift
      parameter :search
      response 200 do
        key :description, 'Tariffs'
        schema do
          key :'$ref', :Tariffs
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
  # GET /admin/tariffs
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    queryShift = pagination_params[:shift] || nil
    querySearch = pagination_params[:search] || nil
    # Seach all Tariffs
    @tariffs = Tariff.all.order(:id)
    # Filter by shift
    if queryShift
      @tariffs = @tariffs.where(shift_name: queryShift)
    end
    # Seah string in name
    if querySearch
      @tariffs = @tariffs.where('driver_name ~* :pat', :pat => querySearch)
    end
    # Define total pages with this perPage
    totalItems = @tariffs.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @tariffs = @tariffs.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @tariffs
  end

  # Swagger
  swagger_path '/admin/tariffs' do
    operation :post do
      key :description, 'Creates a new tariff. Duplicate references are not allowed'
      key :operationId, 'addTariff'
      key :produces, [ 'application/json' ]
      key :tags, [ 'tariffs' ]
      parameter do
        key :name, :tariff
        key :in, :body
        key :description, 'Tariff to add'
        key :required, true
        schema do
          key :'$ref', :CreateTariff
        end
      end
      response 200 do
        key :description, 'Created Tariff'
        schema do
          key :'$ref', :Tariff
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
  # POST /admin/tariffs
  def create
    begin
      tariff = Tariff.new(create_tariff_params)
      if tariff.save
        render json: tariff
      else
        render json: { error: tariff.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/tariffs/{id}' do
    parameter :pathId
    operation :get do
      key :description, 'show tariff'
      key :operationId, 'showTariff'
      key :produces, [ 'application/json' ]
      key :tags, [ 'tariffs' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Tariffs'
        schema do
          key :'$ref', :Tariff
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
  # GET /admin/tariffs/:id
  def show
    render json: @tariff
  end

  # Swagger
  swagger_path '/admin/tariffs/{id}' do
    parameter :pathId
    operation :patch do
      key :description, 'Update tariff'
      key :operationId, 'updateTariff'
      key :produces, [ 'application/json' ]
      key :tags, [ 'tariffs' ]
      parameter :csrfToken
      parameter do
        key :name, :updateTariff
        key :in, :body
        key :description, 'Tariff to update'
        key :required, true
        schema do
          key :'$ref', :UpdateTariff
        end
      end
      response 200 do
        key :description, 'Tariff to update'
        schema do
          key :'$ref', :Tariff
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
  # PATHC /admin/tariffs/:id
  def update
    @tariff.update!(tariff_params)
    render json: @tariff
  end

  # Swagger
  swagger_path '/admin/tariffs/{id}' do
    parameter :pathId
    operation :delete do
      key :description, 'Delete tariff'
      key :operationId, 'deleteTariff'
      key :produces, [ 'application/json' ]
      key :tags, [ 'tariffs' ]
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
  # DELETE /admin/tariffs/:id
  def destroy
    @tariff.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_tariff
    @tariff = Tariff.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def tariff_params
    params.require(:tariff).permit(:id, :driver_name, :vehicle_plate, :shift_name, :shift_date, :owner_tariff, :paid, :debt, :comments, :status)
  end

  def create_tariff_params
    params.permit(:id, :driver_name, :vehicle_plate, :shift_name, :shift_date, :owner_tariff, :paid, :debt, :comments, :status)
  end
end
