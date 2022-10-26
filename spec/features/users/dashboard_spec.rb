# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Dashboard Page' do
  describe 'When I visit /users/:id where :id is a valid user id', :vcr do
    before :each do
      @user_1 = create(:user)

      @viewing_party1 = create(:viewing_party)
      @viewing_party2 = create(:viewing_party)

      create(:viewing_party_users, user: @user_1, viewing_party: @viewing_party1)
      create(:viewing_party_users, user: @user_1, viewing_party: @viewing_party2)

      visit login_path
      fill_in 'email', with: @user_1.email
      fill_in 'password', with: @user_1.password
      click_on 'Login'
    end

    it 'I should see <users name>s Dashboard at the top of the page' do
      visit dashboard_path

      expect(page).to have_content("#{@user_1.name}'s Dashboard")
    end

    it 'I see A button to Discover Movies' do
      visit dashboard_path
      click_button 'Discover Movies'
      expect(current_path).to eq(user_discover_path)
    end

    it 'A section that lists viewing parties' do
      visit dashboard_path
      expect(page).to have_content('Viewing Parties')
    end
  end

  describe 'user dashboard viewing parties user story', :vcr do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      @user_4 = create(:user)
      @user_5 = create(:user)

      @movie1 = MovieFacade.details_poro(550)
      @movie2 = MovieFacade.details_poro(240)
      visit login_path
      fill_in 'email', with: @user_1.email
      fill_in 'password', with: @user_1.password
      click_on 'Login'
    end
    it 'When I visit user dashboard I see viewing parties that user has been invited too' do
      visit new_user_movie_viewing_party_path(550)
      fill_in "Duration", with: "200"
      fill_in "Date", with: "Tue, 11 Oct 2022"
      fill_in "Time", with: "6:00 PM"
      check "user_#{@user_2.id}" 
      check "user_#{@user_3.id}"
      click_button("Create Party")
      expect(current_path).to eq(dashboard_path)
      
      within "#viewing-parties" do
        expect(page).to have_content(@movie1.title)
        expect(page).to have_content("Duration: 200")
        expect(page).to have_content(@user_2.name)
        expect(page).to have_content(@user_3.name)
      end
    end

    it 'I see should see movie image' do
      visit new_user_movie_viewing_party_path(550)
      fill_in "Duration", with: "200"
      fill_in "Date", with: "Tue, 11 Oct 2022"
      fill_in "Time", with: "6:00 PM"
      check "user_#{@user_2.id}" 
      check "user_#{@user_3.id}"
      click_button("Create Party")

      expect(page).to have_css("img[src='https://image.tmdb.org/t/p/w500/#{@movie1.poster_path}']")
    end
  end
end
