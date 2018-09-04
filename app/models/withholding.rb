class Withholding < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum status: %i[enable disable].freeze

  validates_presence_of :name, :percentage, :withholding_type, :status
  validates_uniqueness_of :name

  def attributes
    { id: id, name: name, percentage: percentage, withholding_type: withholding_type, description: description, status: status }
  end

  # Swagger
  swagger_schema :Withholding do
    key :required, [:id, :name, :percentage, :withholding_type, :status]
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
    property :withholding_type do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :UpdateWithholding do
    key :required, [:withholding]
    property :withholding do
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
      property :typwithholding_typee do
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

  swagger_schema :CreateWithholding do
    key :required, [:name, :percentage, :type, :status]
    property :name do
      key :type, :string
    end
    property :percentage do
      key :type, :decimal
    end
    property :withholding_type do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :Withholdings do
    key :required, [:withholdings]
    property :withholdings do
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
        property :withholding_type do
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