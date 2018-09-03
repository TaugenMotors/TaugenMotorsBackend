require 'rails_helper'

RSpec.describe Term, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      term = build( :term, name: nil ).save
      expect( term ).to equal( false )
    end
    it 'Days presence' do
      term = build( :term, days: nil ).save
      expect( term ).to equal( false )
    end
    it 'status presence' do
      term = build( :term, status: nil ).save
      expect( term ).to equal( false )
    end

    it 'Name uniqueness' do
      term1 = build( :term, name: 'some name' ).save
      expect( term1 ).to equal( true )
      term2 = build( :term, name: 'some name' ).save
      expect( term2 ).to equal( false )
    end

    it 'Creation successfully' do
      term = build( :term ).save
      expect( term ).to equal( true )
    end
  end
end