class Category < ApplicationRecord
  include ActiveModel::Serializers::JSON

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def attributes
    { id: id, name: name, description: description }
  end

  # Swagger
  swagger_schema :Category do
    key :required, [:id, :name, :description]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
  end

  swagger_schema :UpdateCategory do
    key :required, [:category]
    property :category do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :description do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateCategory do
    key :required, [:name, :description]
    property :name do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
  end

  swagger_schema :Categories do
    key :required, [:Category]
    property :Category do
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
        property :description do
          key :type, :string
        end
      end
    end
  end
end
