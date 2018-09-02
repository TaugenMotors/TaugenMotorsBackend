class Api::V1::Admin::CategoriesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_category, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin owner].freeze
  EDIT_ROLES = %w[admin].freeze

  # Swagger
  swagger_path '/admin/categories' do
    operation :get do
      key :description, 'get categories'
      key :operationId, 'getCategories'
      key :produces, [ 'application/json' ]
      key :tags, [ 'categories' ]
      parameter :csrfToken
      parameter :page
      parameter :perPage
      parameter :search
      response 200 do
        key :description, 'Categories'
        schema do
          key :'$ref', :Categories
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
  # GET /admin/categories
  def index
    page = ( pagination_params[:page] || 1 ).to_i
    perPage = ( pagination_params[:perPage] || 10 ).to_i
    querySearch = pagination_params[:search] || nil
    # Seach all categories
    @categories = Category.all.order(:id)
    # Seah string in name
    if querySearch
      @categories = @categories.where('name ~* :pat', :pat => querySearch)
    end
    # Define total pages with this perPage
    totalItems = @categories.length
    if totalItems > 0
      totalPages = ( totalItems / perPage.to_f ).ceil
      page = totalPages >= page ? page : totalPages
      offset = ( page - 1 ) * perPage
      @categories = @categories.limit(perPage).offset(offset)
    end

    response.set_header( 'TOTAL-PAGES', totalPages )
    render json: @categories
  end

  # Swagger
  swagger_path '/admin/categories' do
    operation :post do
      key :description, 'Creates a new category. Duplicate name are not allowed'
      key :operationId, 'addCategory'
      key :produces, [ 'application/json' ]
      key :tags, [ 'categories' ]
      parameter do
        key :name, :category
        key :in, :body
        key :description, 'Category to add'
        key :required, true
        schema do
          key :'$ref', :CreateCategory
        end
      end
      response 200 do
        key :description, 'Created Category'
        schema do
          key :'$ref', :Category
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
  # POST /admin/categories
  def create
    begin
      category = Category.new(create_category_params)
      if category.save
        render json: category
      else
        render json: { error: category.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  # Swagger
  swagger_path '/admin/categories/{id}' do
    parameter :pathCategoryId
    operation :get do
      key :description, 'show category'
      key :operationId, 'showCategory'
      key :produces, [ 'application/json' ]
      key :tags, [ 'categories' ]
      parameter :csrfToken
      response 200 do
        key :description, 'Categorys'
        schema do
          key :'$ref', :Category
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
  # GET /admin/categories/:id
  def show
    render json: @category
  end

  # Swagger
  swagger_path '/admin/categories/{id}' do
    parameter :pathCategoryId
    operation :patch do
      key :description, 'Update category'
      key :operationId, 'updateCategory'
      key :produces, [ 'application/json' ]
      key :tags, [ 'categories' ]
      parameter :csrfToken
      parameter do
        key :name, :updateCategory
        key :in, :body
        key :description, 'Category to update'
        key :required, true
        schema do
          key :'$ref', :UpdateCategory
        end
      end
      response 200 do
        key :description, 'Category to update'
        schema do
          key :'$ref', :Category
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
  # PATHC /admin/categories/:id
  def update
    @category.update!(category_params)
    render json: @category
  end

  # Swagger
  swagger_path '/admin/categories/{id}' do
    parameter :pathCategoryId
    operation :delete do
      key :description, 'Delete category'
      key :operationId, 'deleteCategory'
      key :produces, [ 'application/json' ]
      key :tags, [ 'categories' ]
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
  # DELETE /admin/categories/:id
  def destroy
    @category.destroy
    render json: :ok
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def allowed_aud
    ( ['destroy', 'update', 'create'].include? action_name) ? EDIT_ROLES : VIEW_ROLES
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def create_category_params
    params.permit(:name, :description)
  end
end

