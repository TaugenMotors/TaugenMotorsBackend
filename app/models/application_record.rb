class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Swagger::Blocks

  # Swagger
  swagger_schema :ErrorModel do
    key :required, [:error]
    property :error do
      key :type, :string
    end
  end

  swagger_schema :SuccessModel do
    key :required, [:status]
    property :status do
      key :type, :string
    end
  end

  swagger_schema :CsrfTokenModel do
    key :required, [:csrf]
    property :csrf do
      key :type, :string
    end
  end

  swagger_schema :Pagination do
    property :page do
      key :type, :string
    end
    property :perPage do
      key :type, :string
    end
    property :role do
      key :type, :string
    end
    property :search do
      key :type, :string
    end
  end
end
