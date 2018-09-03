class Tax < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum status: %i[enable disable].freeze

  validates_presence_of :name, :percentage, :tax_type, :status
  validates_uniqueness_of :name

  def attributes
    { id: id, name: name, percentage: percentage, tax_type: tax_type, description: description, status: status }
  end

  # Swagger
  swagger_schema :Tax do
    key :required, [:id, :name, :percentage, :tax_type, :status]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :percentage do
      key :type, :decimal
    end
    property :tax_type do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :UpdateTax do
    key :required, [:tax]
    property :tax do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :percentage do
        key :type, :decimal
      end
      property :typtax_typee do
        key :type, :string
      end
      property :description do
        key :type, :string
      end
      property :status do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateTax do
    key :required, [:name, :percentage, :type, :status]
    property :name do
      key :type, :string
    end
    property :percentage do
      key :type, :decimal
    end
    property :tax_type do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :Taxes do
    key :required, [:taxes]
    property :taxes do
      key :type, :array
      items do
        key :type, :object
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :name do
          key :type, :string
        end
        property :percentage do
          key :type, :decimal
        end
        property :tax_type do
          key :type, :string
        end
        property :description do
          key :type, :string
        end
        property :status do
          key :type, :string
        end
      end
    end
  end
end
