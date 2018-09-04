require 'rails_helper'

RSpec.describe Withholding, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      withholding = build( :withholding, name: nil ).save
      expect( withholding ).to equal( false )
    end
    it 'Percentage presence' do
      withholding = build( :withholding, percentage: nil ).save
      expect( withholding ).to equal( false )
    end
    it 'Type presence' do
      withholding = build( :withholding, withholding_type: nil ).save
      expect( withholding ).to equal( false )
    end
    it 'Status presence' do
      withholding = build( :withholding, status: nil ).save
      expect( withholding ).to equal( false )
    end

    it 'Name uniqueness' do
      withholding1 = build( :withholding, name: 'withholding name' ).save
      expect( withholding1 ).to equal( true )
      withholding2 = build( :withholding, name: 'withholding name' ).save
      expect( withholding2 ).to equal( false )
    end

    it 'Creation successfully' do
      withholding = build( :withholding ).save
      expect( withholding ).to equal( true )
    end
  end
end