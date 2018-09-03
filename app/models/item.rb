class Item < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum status: %i[enable disable].freeze

  validates_presence_of :name, :price, :reference, :status
  validates_uniqueness_of :reference

  def attributes
    { id: id, name: name, reference: reference, price: price, tax: tax, description: description, provider: provider, status: status }
  end

  # Swagger
  swagger_schema :Item do
    key :required, [:id, :name, :reference, :price, :tax, :description, :provider, :status]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :reference do
      key :type, :string
    end
    property :price do
      key :type, :decimal
    end
    property :tax do
      key :type, :float
    end
    property :description do
      key :type, :string
    end
    property :provider do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :UpdateItem do
    key :required, [:item]
    property :item do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :reference do
        key :type, :string
      end
      property :price do
        key :type, :decimal
      end
      property :tax do
        key :type, :float
      end
      property :description do
        key :type, :string
      end
      property :provider do
        key :type, :string
      end
      property :status do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateItem do
    key :required, [:name, :reference, :price, :status]
    property :name do
      key :type, :string
    end
    property :reference do
      key :type, :string
    end
    property :price do
      key :type, :decimal
    end
    property :tax do
      key :type, :float
    end
    property :description do
      key :type, :string
    end
    property :provider do
      key :type, :string
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :Items do
    key :required, [:items]
    property :items do
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
        property :reference do
          key :type, :string
        end
        property :price do
          key :type, :decimal
        end
        property :tax do
          key :type, :float
        end
        property :description do
          key :type, :string
        end
        property :provider do
          key :type, :string
        end
        property :status do
          key :type, :string
        end
      end
    end
  end
end
