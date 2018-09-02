class Item < ApplicationRecord
  include ActiveModel::Serializers::JSON

  validates_presence_of :name, :price, :reference
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
      key :type, :boolean
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
        key :type, :boolean
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
      key :type, :boolean
    end
  end

  swagger_schema :Items do
    key :required, [:Items]
    property :Items do
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
          key :type, :boolean
        end
      end
    end
  end
end
