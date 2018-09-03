class Term < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum status: %i[enable disable].freeze

  validates_presence_of :name, :days, :status
  validates_uniqueness_of :name

  def attributes
    { id: id, name: name, days: days, status: status }
  end

  # Swagger
  swagger_schema :Term do
    key :required, [:id, :name, :days, :status]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :days do
      key :type, :integer
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :UpdateTerm do
    key :required, [:term]
    property :term do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :days do
        key :type, :integer
      end
      property :status do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateTerm do
    key :required, [:name, :days, :status]
    property :name do
      key :type, :string
    end
    property :days do
      key :type, :integer
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :Terms do
    key :required, [:terms]
    property :terms do
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
        property :days do
          key :type, :integer
        end
        property :status do
          key :type, :string
        end
      end
    end
  end
end
