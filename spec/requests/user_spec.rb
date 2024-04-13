require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    let!(:user1) { FactoryBot.create(:user, name: 'Bob Bobson') }
    let!(:user2) { FactoryBot.create(:user, name: 'Hugh Mann') }
    it 'do' do
      visit('/')
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
    end
  end
end
