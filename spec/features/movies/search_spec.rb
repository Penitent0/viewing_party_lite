# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Search Page' do
  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)

    visit login_path
    fill_in 'email', with: @user_1.email
    fill_in 'password', with: @user_1.password
    click_on 'Login'
  end
  # As an user,
  # When I visit the '/users/:id/discover' path, where :id, is the id of a valid user,
  # I should see

  # Button to Discover Top Rated Movies
  # A text field to enter keyword(s) to search by movie title
  # A Button to Search by Movie Title
  # Details When the user clicks on the Top Rated Movies OR the search button, they should be taken to the movies results page (more details of this on the Movies Results Page issue.
  describe 'When I visit the /users/:id/discover path', :vcr do
    it 'I should see button to Find Top Rated Movies' do
      visit user_discover_path

      click_button 'Find Top Rated Movies'
    end

    it 'A text field to enter keyword(s) to search by movie title' do
      visit user_discover_path

      fill_in 'Search movies', with: 'Dark Knight'
      click_on 'Find Movies'
    end

    it 'redirects back to discover page if no option select with sad path' do
      visit user_discover_path

      click_on 'Find Movies'

      expect(current_path).to eq(user_discover_path)
      expect(page).to have_content('Must Select Top Rated Movies or Search for Keyword')
    end
  end
end
