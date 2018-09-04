FactoryBot.define do
  factory :withholding do
    name { Faker::Commerce.product_name }
    percentage { Faker::Number.decimal(2, 1) }
    withholding_type 'Retención en la fuente'
    description { Faker::Commerce.department }
    status 'enable'
  end
end
