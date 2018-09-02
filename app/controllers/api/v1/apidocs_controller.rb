class Api::V1::ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Taugen Motors Backend'
      key :description, 'An API for the Taugen Motros Backend'
      contact do
        key :name, 'Dev API Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, ENV['HOST']
    key :basePath, '/api/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']

    # Reusable parameters
    parameter :pathUserId do
      key :name, :id
      key :in, :path
      key :description, 'User ID'
      key :required, true
      key :type, :string
    end
    parameter :pathItemId do
      key :name, :id
      key :in, :path
      key :description, 'Item ID'
      key :required, true
      key :type, :string
    end
    parameter :pathCategoryId do
      key :name, :id
      key :in, :path
      key :description, 'Category ID'
      key :required, true
      key :type, :string
    end
    parameter :csrfToken do
      key :name, 'X-CSRF-TOKEN'
      key :in, :header
      key :description, 'Token'
      key :required, true
    end
    parameter :page do
      key :name, :page
      key :in, :query
      key :description, 'Page'
      key :required, false
      key :type, :string
    end
    parameter :perPage do
      key :name, :perPage
      key :in, :query
      key :description, 'Items per page'
      key :required, false
      key :type, :string
    end
    parameter :role do
      key :name, :role
      key :in, :query
      key :description, 'Role to search for'
      key :required, false
      key :type, :string
    end
    parameter :search do
      key :name, :search
      key :in, :query
      key :description, 'Word to search for'
      key :required, false
      key :type, :string
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    ApplicationController,
    ApplicationRecord,
    Api::V1::SigninController,
    Api::V1::SigninController,
    Api::V1::RefreshController,
    Api::V1::PasswordResetsController,
    Api::V1::UsersController,
    Api::V1::Admin::UsersController,
    Api::V1::Admin::ItemsController,
    Api::V1::Admin::CategoriesController,
    User,
    Item,
    Category,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end