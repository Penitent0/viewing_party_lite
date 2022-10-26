# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'landing page' do
  # When a user visits the root path they should be on the landing page ('/') which includes:

  # Title of Application
  # Button to Create a New User
  # List of Existing Users which links to the users dashboard
  # Link to go back to the landing page (this link will be present at the top of all pages)

  describe 'Landing Page User Story' do
    before :each do
      @user_1 = create(:user)
      visit login_path
      fill_in 'email', with: @user_1.email
      fill_in 'password', with: @user_1.password
      click_on 'Login'
    end
    it 'When a user visits the root path they should be on the landing page and user name is link to user dashboard' do
      visit landing_page_path

      expect(page).to have_content('Viewing Party Lite')
      click_link @user_1.name.to_s
      expect(current_path).to eq(dashboard_path)
    end

    it 'has button to create new user and landing page link on all pages' do
      visit landing_page_path

      click_button 'Create New User'

      expect(current_path).to eq(register_path)

      click_link 'Landing Page'
      expect(current_path).to eq(landing_page_path)
    end
  end
end
