require 'rails_helper'

RSpec.describe "Auctions", type: :request do
  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:auction) { FactoryBot.create(:auction, name: 'A blind date with a Bob.', user: user) }
    it 'do' do
      visit("/users/#{user.id}")
      expect(page).to have_content(user.name)
      expect(page).to have_content(auction.name)
    end
  end
end
