FactoryBot.define do
  factory :term do
    name { Faker::Commerce.product_name }
    days { Faker::Number.number(2) }
    status 'enable'
  end
end
