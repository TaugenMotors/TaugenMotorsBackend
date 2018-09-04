require 'rails_helper'

RSpec.describe Tariff, type: :model do
  context 'Validation test' do
    it 'Driver_name presence' do
      tariff = build( :tariff, driver_name: nil ).save
      expect( tariff ).to equal( false )
    end
    it 'Vehicle plate presence' do
      tariff = build( :tariff, vehicle_plate: nil ).save
      expect( tariff ).to equal( false )
    end
    it 'Owner tariff presence' do
      tariff = build( :tariff, owner_tariff: nil ).save
      expect( tariff ).to equal( false )
    end
    it 'Paid tariff presence' do
      tariff = build( :tariff, paid: nil ).save
      expect( tariff ).to equal( false )
    end
    it 'Debt tariff presence' do
      tariff = build( :tariff, debt: nil ).save
      expect( tariff ).to equal( false )
    end
    it 'status presence' do
      tariff = build( :tariff, status: nil ).save
      expect( tariff ).to equal( false )
    end

    it 'Paid can not be larger than owner tariff' do
      tariff = build( :tariff, owner_tariff: "100.00", paid: "110.00" ).save
      created_tariff = Tariff.last
      expect( tariff ).to equal( false )
    end

    it 'Creation successfully' do
      tariff = build( :tariff ).save
      created_tariff = Tariff.last
      debt = created_tariff.owner_tariff - created_tariff.paid
      expect( tariff ).to equal( true )
      expect( created_tariff.debt ).to eq( debt )
    end
  end
end
