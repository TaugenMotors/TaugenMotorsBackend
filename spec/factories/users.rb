FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    telephone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
  end
end
