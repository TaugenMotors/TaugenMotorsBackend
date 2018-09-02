FactoryBot.define do
  factory :category do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.department }
  end
end
