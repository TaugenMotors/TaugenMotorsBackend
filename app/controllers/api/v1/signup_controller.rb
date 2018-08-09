class Api::V1::SignupController < ApplicationController
  # Swagger
  swagger_path '/signup' do
    operation :post do
      key :description, 'Creates a new user. Duplicates are not allowed'
      key :operationId, 'addUser'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'users'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'User to add'
        key :required, true
        schema do
          key :'$ref', :CreateUser
        end
      end
      response 200 do
        key :description, 'Created User'
        schema do
          key :'$ref', :User
        end
      end
      response 422 do
        key :description, 'Unprocessable Entity'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # POST /api/v1/signup
  def create
    secretPassword = SecureRandom.base64(15)
    begin
      user = User.new(user_params.merge({ password: secretPassword, password_confirmation: secretPassword }))
      if user.save
        user.generate_password_token!
        UserMailer.reset_password(user).deliver_now
        render json: user
      else
        render json: { error: user.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :name, :telephone, :role)
  end
end
