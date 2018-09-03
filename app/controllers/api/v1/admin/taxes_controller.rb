class Api::V1::Admin::TaxesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_tax, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/taxes' do
    operation :get do
      key :description, 'get taxes'
      key :operationId, 'getTaxes'
      key :produces, [ 'application/json' ]
      key :tags, [ 'taxes' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :search
      response 200 do
        key :description, 'Taxes'
        schema do
          key :'$ref', :Taxes
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
  # GET /admin/taxes
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    # Seach all Taxes
    @taxes = Tax.all.order(:id)
    # Define total pages with this perPage
    totalItems = @taxes.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @taxes = @taxes.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @taxes
  end

  # Swagger
  swagger_path '/admin/taxes' do
    operation :post do
      key :description, 'Creates a new tax. Duplicate names are not allowed'
      key :operationId, 'addTax'
      key :produces, [ 'application/json' ]
      key :tags, [ 'taxes' ]
      parameter do
        key :name, :tax
        key :in, :body
        key :description, 'Tax to add'
        key :required, true
        schema do
          key :'$ref', :CreateTax
        end
      end
      response 200 do
        key :description, 'Created Tax'
        schema do
          key :'$ref', :Tax
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
  # POST /admin/taxes
  def create
    begin
      tax = Tax.new(create_tax_params)
      if tax.save
        render json: tax
      else
        render json: { error: tax.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/taxes/{id}' do
    parameter :pathTaxId
    operation :get do
      key :description, 'show tax'
      key :operationId, 'showTax'
      key :produces, [ 'application/json' ]
      key :tags, [ 'taxes' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Taxes'
        schema do
          key :'$ref', :Tax
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
  # GET /admin/taxes/:id
  def show
    render json: @tax
  end

  # Swagger
  swagger_path '/admin/taxes/{id}' do
    parameter :pathTaxId
    operation :patch do
      key :description, 'Update tax'
      key :operationId, 'updateTax'
      key :produces, [ 'application/json' ]
      key :tags, [ 'taxes' ]
      parameter :csrfToken
      parameter do
        key :name, :updateTax
        key :in, :body
        key :description, 'Tax to update'
        key :required, true
        schema do
          key :'$ref', :UpdateTax
        end
      end
      response 200 do
        key :description, 'Tax to update'
        schema do
          key :'$ref', :Tax
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
  # PATHC /admin/taxes/:id
  def update
    @tax.update!(tax_params)
    render json: @tax
  end

  # Swagger
  swagger_path '/admin/taxes/{id}' do
    parameter :pathTaxId
    operation :delete do
      key :description, 'Delete tax'
      key :operationId, 'deleteTax'
      key :produces, [ 'application/json' ]
      key :tags, [ 'taxes' ]
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
  # DELETE /admin/taxes/:id
  def destroy
    @tax.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_tax
    @tax = Tax.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def tax_params
    params.require(:tax).permit(:name, :percentage, :description, :tax_type, :status)
  end

  def create_tax_params
    params.permit(:name, :percentage, :description, :tax_type, :status)
  end
end
