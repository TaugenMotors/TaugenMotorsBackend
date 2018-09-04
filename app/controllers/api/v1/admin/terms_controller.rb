class Api::V1::Admin::TermsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_term, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/terms' do
    operation :get do
      key :description, 'get terms'
      key :operationId, 'getTerms'
      key :produces, [ 'application/json' ]
      key :tags, [ 'terms' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      response 200 do
        key :description, 'Terms'
        schema do
          key :'$ref', :Terms
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
  # GET /admin/terms
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    # Seach all Terms
    @terms = Term.all.order(:id)
    # Define total pages with this perPage
    totalTerms = @terms.length
    if totalTerms > 0
      totalPages = ( totalTerms / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @terms = @terms.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @terms
  end

  # Swagger
  swagger_path '/admin/terms' do
    operation :post do
      key :description, 'Creates a new term. Duplicate names are not allowed'
      key :operationId, 'addTerm'
      key :produces, [ 'application/json' ]
      key :tags, [ 'terms' ]
      parameter do
        key :name, :term
        key :in, :body
        key :description, 'Term to add'
        key :required, true
        schema do
          key :'$ref', :CreateTerm
        end
      end
      response 200 do
        key :description, 'Created Term'
        schema do
          key :'$ref', :Term
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
  # POST /admin/terms
  def create
    begin
      term = Term.new(create_term_params)
      if term.save
        render json: term
      else
        render json: { error: term.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/terms/{id}' do
    parameter :pathId
    operation :get do
      key :description, 'show term'
      key :operationId, 'showTerm'
      key :produces, [ 'application/json' ]
      key :tags, [ 'terms' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Terms'
        schema do
          key :'$ref', :Term
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
  # GET /admin/terms/:id
  def show
    render json: @term
  end

  # Swagger
  swagger_path '/admin/terms/{id}' do
    parameter :pathId
    operation :patch do
      key :description, 'Update term'
      key :operationId, 'updateTerm'
      key :produces, [ 'application/json' ]
      key :tags, [ 'terms' ]
      parameter :csrfToken
      parameter do
        key :name, :updateTerm
        key :in, :body
        key :description, 'Term to update'
        key :required, true
        schema do
          key :'$ref', :UpdateTerm
        end
      end
      response 200 do
        key :description, 'Term to update'
        schema do
          key :'$ref', :Term
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
  # PATHC /admin/terms/:id
  def update
    @term.update!(term_params)
    render json: @term
  end

  # Swagger
  swagger_path '/admin/terms/{id}' do
    parameter :pathId
    operation :delete do
      key :description, 'Delete term'
      key :operationId, 'deleteTerm'
      key :produces, [ 'application/json' ]
      key :tags, [ 'terms' ]
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
  # DELETE /admin/terms/:id
  def destroy
    @term.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_term
    @term = Term.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def term_params
    params.require(:term).permit(:name, :days, :status)
  end

  def create_term_params
    params.permit(:name, :days, :status)
  end
end
