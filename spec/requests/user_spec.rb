require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET index" do
    let!(:user1) { FactoryBot.create(:user, name: 'Bob Bobson') }
    let!(:user2) { FactoryBot.create(:user, name: 'Hugh Mann') }
    it 'do' do
      visit('/')
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
    end
  end

  describe "GET users show" do
    let!(:user) { FactoryBot.create(:user, name: 'Bob Bobson') }
    it 'do' do
      visit("/users/#{user.id}")
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.phone_number)
    end
  end

  describe "new" do
    context "with no unpaid dinners" do
      it 'does not create an auction' do
        expect {
          visit('/users/new')

          fill_in 'Name', with: 'Bob Bobson'
          fill_in 'Phone number', with: '5555555555'

          click_button 'Create User'
        }.not_to change { Auction.count }

        expect(page).to have_content('Paddle number:')
        expect(page).to have_content(User.last.id)
      end
    end

    context 'with unpaid dinners' do
      it 'creates two auctions' do
        expect {
          visit('/users/new')

          fill_in 'Name', with: 'Bob Bobson'
          fill_in 'Phone number', with: '5555555555'
          fill_in 'Unpaid dinners', with: '2'

          click_button 'Create User'
        }.to change { Auction.count }.by(2)

        expect(page).to have_content('Paddle number:')
        expect(page).to have_content(User.last.id)
      end
    end
  end

  describe 'adding a new auction from users show page' do
    let!(:user) { FactoryBot.create(:user, name: 'Bob Bobson') }

    it 'creates two auctions' do
      expect {
        visit("/users/#{user.id}")

        fill_in 'Value', with: '5.50'
        fill_in 'Name', with: 'A special night with Bob.'
        fill_in 'Quantity', with: '2'

        click_button 'Create Auction'
      }.to change { Auction.count }.by(2)

      expect(page).to have_content(user.name)
      expect(page).to have_content('A special night with Bob.')
    end
  end
end
