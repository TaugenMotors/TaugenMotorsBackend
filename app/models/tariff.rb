class Tariff < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum status: %i[pendiente pagado].freeze

  validates_presence_of :driver_name, :vehicle_plate, :status, :owner_tariff, :paid, :debt

  before_save :set_tariff_state

  def attributes
    {
      id: id,
      driver_name: driver_name,
      vehicle_plate: vehicle_plate,
      shift_name: shift_name,
      shift_date: shift_date,
      owner_tariff: owner_tariff,
      paid: paid,
      debt: debt,
      comments: comments,
      status: status
    }
  end

  private
  def set_tariff_state
    if self.paid < self.owner_tariff
      self.debt = self.owner_tariff - self.paid
    else
      errors.add(:base, "The payment is larger than the owner's tariff")
      throw(:abort)
    end
  end

  # Swagger
  swagger_schema :Tariff do
    key :required, [:id, :driver_name, :vehicle_plate, :shift_name, :shift_date, :owner_tariff, :paid, :debt, :comments, :status]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :driver_name do
      key :type, :string
    end
    property :vehicle_plate do
      key :type, :string
    end
    property :shift_name do
      key :type, :string
    end
    property :shift_date do
      key :type, :date
    end
    property :owner_tariff do
      key :type, :decimal
    end
    property :paid do
      key :type, :decimal
    end
    property :debt do
      key :type, :decimal
    end
    property :comments do
      key :type, :text
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :UpdateTariff do
    key :required, [:tariff]
    property :tariff do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :driver_name do
        key :type, :string
      end
      property :vehicle_plate do
        key :type, :string
      end
      property :shift_name do
        key :type, :string
      end
      property :shift_date do
        key :type, :date
      end
      property :owner_tariff do
        key :type, :decimal
      end
      property :paid do
        key :type, :decimal
      end
      property :debt do
        key :type, :decimal
      end
      property :comments do
        key :type, :text
      end
      property :status do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateTariff do
    key :required, [:user_id, :vehicle_id, :owner_tariff, :paid, :status]
    property :user_id do
      key :type, :string
    end
    property :vehicle_id do
      key :type, :string
    end
    property :shift_name do
      key :type, :string
    end
    property :shift_date do
      key :type, :date
    end
    property :owner_tariff do
      key :type, :decimal
    end
    property :paid do
      key :type, :decimal
    end
    property :comments do
      key :type, :text
    end
    property :status do
      key :type, :string
    end
  end

  swagger_schema :Tariffs do
    key :required, [:tariffs]
    property :tariffs do
      key :type, :array
      items do
        key :type, :object
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :driver_name do
          key :type, :string
        end
        property :vehicle_plate do
          key :type, :string
        end
        property :shift_name do
          key :type, :string
        end
        property :shift_date do
          key :type, :date
        end
        property :owner_tariff do
          key :type, :decimal
        end
        property :paid do
          key :type, :decimal
        end
        property :debt do
          key :type, :decimal
        end
        property :comments do
          key :type, :text
        end
        property :status do
          key :type, :string
        end
      end
    end
  end
end