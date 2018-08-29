require 'rails_helper'

RSpec.describe Item, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      item = build( :item, name: nil ).save
      expect( item ).to equal( false )
    end
    it 'Price presence' do
      item = build( :item, price: nil ).save
      expect( item ).to equal( false )
    end
    it 'Reference presence' do
      item = build( :item, reference: nil ).save
      expect( item ).to equal( false )
    end

    it 'Reference uniqueness' do
      item1 = build( :item, reference: '1234567890' ).save
      expect( item1 ).to equal( true )
      item2 = build( :item, reference: '1234567890' ).save
      expect( item2 ).to equal( false )
    end

    it 'Creation successfully' do
      item = build( :item ).save
      expect( item ).to equal( true )
    end
  end
end
