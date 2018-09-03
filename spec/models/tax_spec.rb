require 'rails_helper'

RSpec.describe Tax, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      tax = build( :tax, name: nil ).save
      expect( tax ).to equal( false )
    end
    it 'Percentage presence' do
      tax = build( :tax, percentage: nil ).save
      expect( tax ).to equal( false )
    end
    it 'Type presence' do
      tax = build( :tax, tax_type: nil ).save
      expect( tax ).to equal( false )
    end
    it 'Status presence' do
      tax = build( :tax, status: nil ).save
      expect( tax ).to equal( false )
    end

    it 'Name uniqueness' do
      tax1 = build( :tax, name: 'tax name' ).save
      expect( tax1 ).to equal( true )
      tax2 = build( :tax, name: 'tax name' ).save
      expect( tax2 ).to equal( false )
    end

    it 'Creation successfully' do
      tax = build( :tax ).save
      expect( tax ).to equal( true )
    end
  end
end
