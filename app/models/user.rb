class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password

  # Administrador = admin
  # Propietario = owner
  # Conductor = driver
  # Empleado
  # - Jefe de patio = inspector
  # - Auxiliar administrativa = manager

  enum role: %i[manager inspector driver owner admin].freeze

  validates             :email,
                        format: { with: URI::MailTo::EMAIL_REGEXP },
                        presence: true,
                        uniqueness: { case_sensitive: false }
  validates_presence_of :name, :telephone

  def attributes
    { id: id, email: email, role: role, name: name, telephone: telephone }
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end

  # Swagger
  swagger_schema :User do
    key :required, [:id, :email, :name, :telephone, :role]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :email do
      key :type, :string
    end
    property :name do
      key :type, :string
    end
    property :telephone do
      key :type, :string
    end
    property :role do
      key :type, :string
    end
  end

  swagger_schema :UpdateUser do
    key :required, [:user]
    property :user do
      key :type, :object
      property :role do
        key :type, :string
      end
    end
  end

  swagger_schema :CreateUser do
    key :required, [:email, :name, :telephone, :role]
    property :email do
      key :type, :string
    end
    property :name do
      key :type, :string
    end
    property :telephone do
      key :type, :string
    end
    property :role do
      key :type, :string
    end
  end

  swagger_schema :AuthUser do
    key :required, [:email, :password]
    property :email do
      key :type, :string
    end
    property :password do
      key :type, :string
    end
  end

  swagger_schema :SendResetPassword do
    key :required, [:email]
    property :email do
      key :type, :string
    end
  end

  swagger_schema :ResetPassword do
    key :required, [:password, :password_confirmation]
    property :password do
      key :type, :string
    end
    property :password_confirmation do
      key :type, :string
    end
  end

  swagger_schema :Users do
    key :required, [:Users]
    property :Users do
      key :type, :array
      items do
        key :type, :object
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :email do
          key :type, :string
        end
        property :name do
          key :type, :string
        end
        property :telephone do
          key :type, :string
        end
        property :role do
          key :type, :string
        end
      end
    end
  end

end
