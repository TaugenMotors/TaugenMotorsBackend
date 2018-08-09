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
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    ApplicationController,
    ApplicationRecord,
    SignupController,
    SigninController,
    RefreshController,
    PasswordResetsController,
    UsersController,
    Admin::UsersController,
    User,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end