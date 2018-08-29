FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    reference { Faker::Number.number(10) }
    price { Faker::Number.decimal(5, 3) }
    tax { Faker::Number.decimal(2, 1) }
    description { Faker::Commerce.department }
    provider { Faker::Company.name }
    status true
  end
end