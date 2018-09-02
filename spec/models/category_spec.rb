require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      category = build( :category, name: nil ).save
      expect( category ).to equal( false )
    end
    it 'Description presence' do
      category = build( :category, description: nil ).save
      expect( category ).to equal( false )
    end

    it 'Name uniqueness' do
      category1 = build( :category, name: 'some name' ).save
      expect( category1 ).to equal( true )
      category2 = build( :category, name: 'some name' ).save
      expect( category2 ).to equal( false )
    end

    it 'Creation successfully' do
      category = build( :category ).save
      expect( category ).to equal( true )
    end
  end
end
