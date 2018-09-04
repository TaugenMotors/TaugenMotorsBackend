FactoryBot.define do
  factory :tariff do
    driver_name { Faker::Name.name }
    vehicle_plate 'QFC-426'
    shift_name '1st turn'
    shift_date { Faker::Date.forward(2) }
    owner_tariff { Faker::Number.decimal(5, 2) }
    paid { Faker::Number.decimal(4, 2) }
    debt { Faker::Number.decimal(4, 2) }
    comments { Faker::MostInterestingManInTheWorld.quote }
    status 'pendiente'
  end
end
