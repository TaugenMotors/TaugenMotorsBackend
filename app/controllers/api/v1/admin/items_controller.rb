class Api::V1::Admin::ItemsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_item, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/items' do
    operation :get do
      key :description, 'get items'
      key :operationId, 'getItems'
      key :produces, [ 'application/json' ]
      key :tags, [ 'items' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :search
      response 200 do
        key :description, 'Items'
        schema do
          key :'$ref', :Items
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
  # GET /admin/items
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    querySearch = pagination_params[:search] || nil
    # Seach all Items
    @items = Item.all.order(:id)
    # Seah string in name
    if querySearch
      @items = @items.where('name ~* :pat', :pat => querySearch)
    end
    # Define total pages with this perPage
    totalItems = @items.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @items = @items.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @items
  end

  # Swagger
  swagger_path '/admin/items' do
    operation :post do
      key :description, 'Creates a new item. Duplicate references are not allowed'
      key :operationId, 'addItem'
      key :produces, [ 'application/json' ]
      key :tags, [ 'items' ]
      parameter do
        key :name, :item
        key :in, :body
        key :description, 'Item to add'
        key :required, true
        schema do
          key :'$ref', :CreateItem
        end
      end
      response 200 do
        key :description, 'Created Item'
        schema do
          key :'$ref', :Item
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
  # POST /admin/items
  def create
    begin
      item = Item.new(create_item_params)
      if item.save
        render json: item
      else
        render json: { error: item.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/items/{id}' do
    parameter :pathId
    operation :get do
      key :description, 'show item'
      key :operationId, 'showItem'
      key :produces, [ 'application/json' ]
      key :tags, [ 'items' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Items'
        schema do
          key :'$ref', :Item
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
  # GET /admin/items/:id
  def show
    render json: @item
  end

  # Swagger
  swagger_path '/admin/items/{id}' do
    parameter :pathId
    operation :patch do
      key :description, 'Update item'
      key :operationId, 'updateItem'
      key :produces, [ 'application/json' ]
      key :tags, [ 'items' ]
      parameter :csrfToken
      parameter do
        key :name, :updateItem
        key :in, :body
        key :description, 'Item to update'
        key :required, true
        schema do
          key :'$ref', :UpdateItem
        end
      end
      response 200 do
        key :description, 'Item to update'
        schema do
          key :'$ref', :Item
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
  # PATHC /admin/items/:id
  def update
    @item.update!(item_params)
    render json: @item
  end

  # Swagger
  swagger_path '/admin/items/{id}' do
    parameter :pathId
    operation :delete do
      key :description, 'Delete item'
      key :operationId, 'deleteItem'
      key :produces, [ 'application/json' ]
      key :tags, [ 'items' ]
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
  # DELETE /admin/items/:id
  def destroy
    @item.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def item_params
    params.require(:item).permit(:name, :reference, :price, :tax, :description, :provider, :status)
  end

  def create_item_params
    params.permit(:name, :reference, :price, :tax, :description, :provider, :status)
  end
end
