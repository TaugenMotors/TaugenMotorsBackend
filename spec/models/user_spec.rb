require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Validation test' do
    it 'Name presence' do
      user = build( :user, name: nil ).save
      expect( user ).to equal( false )
    end
    it 'Email presence' do
      user = build( :user, email: nil ).save
      expect( user ).to equal( false )
    end
    it 'Telephone number presence' do
      user = build( :user, telephone: nil ).save
      expect( user ).to equal( false )
    end

    it 'Email uniqueness' do
      user1 = build( :user, email: 'user@test.com' ).save
      expect( user1 ).to equal( true )
      user2 = build( :user, email: 'user@test.com' ).save
      expect( user2 ).to equal( false )
    end

    it 'Email format' do
      user = build( :user, email: 'badEmailFormat' ).save
      expect( user ).to equal( false )
    end

    it 'Creation successfully' do
      user = build( :user ).save
      expect( user ).to equal( true )
    end
  end
end
