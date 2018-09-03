FactoryBot.define do
  factory :tax do
    name { Faker::Commerce.product_name }
    percentage { Faker::Number.decimal(2, 1) }
    tax_type 'IVA'
    description { Faker::Commerce.department }
    status 'enable'
  end
end
