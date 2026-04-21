require 'rails_helper'

RSpec.feature 'Dashboard Profile Index', type: :feature do
  let(:password) { 'P@ssw0rd!!' }
  let(:user) { create(:user, email_address: 'test@example.com', password: password) }

  before do
    dashboard_setup
    login_with(user.email_address, password)
  end

  scenario 'User can see profile page' do
    visit dashboard_profile_path

    expect(page).to have_text('profile settings for days, yo')
  end

  scenario 'User can see the profile link in the sidebar' do
    visit dashboard_index_path

    expect(page).to have_css('div#dashboard-sidebar')
  end

  describe 'Password Management' do
    let(:new_password) { 'ALegitPassword' }

    before do
      visit dashboard_profile_path
    end

    scenario 'User successfully changes their password' do
      fill_in 'current_password', with: password
      fill_in 'new_password', with: new_password
      fill_in 'confirm_password', with: new_password

      click_button 'Set New Password'

      expect(page).to have_content('Successfully changed password')
      expect(page).not_to have_content('Something went wrong. Please try again.')
    end

    scenario 'User accidentally puts in same password' do
      fill_in 'current_password', with: password
      fill_in 'new_password', with: password
      fill_in 'confirm_password', with: password

      click_button 'Set New Password'

      expect(page).not_to have_content('Successfully changed password')
      expect(page).to have_content('Something went wrong. Please try again.')
    end

    scenario 'User puts in wrong password for current password' do
      fill_in 'current_password', with: 'Not the password'
      fill_in 'new_password', with: new_password
      fill_in 'confirm_password', with: new_password

      click_button 'Set New Password'

      expect(page).not_to have_content('Successfully changed password')
      expect(page).to have_content('Something went wrong. Please try again.')
    end

    scenario 'User doesn\'t repeat new password for confirm password' do
      fill_in 'current_password', with: password
      fill_in 'new_password', with: new_password
      fill_in 'confirm_password', with: "#{new_password}!!"

      click_button 'Set New Password'

      expect(page).not_to have_content('Successfully changed password')
      expect(page).to have_content('Something went wrong. Please try again.')
    end
  end

  describe 'Account Deletion' do
    before do
      visit dashboard_profile_path
    end

    scenario 'User wants to delete their account' do
      email_address = user.email_address

      click_button 'Delete Account'

      click_button 'Yes'

      expect(page).to have_current_path(root_path)

      click_link 'Log In'

      fill_in 'email_address', with: email_address
      fill_in 'password', with: password

      click_button 'Sign in'

      expect(page).to have_current_path(new_session_path)
      expect(page).to have_content('Try another email address or password.')
      expect(User.count).to eq(0)
    end

    scenario 'User changes mind while deleting their account' do
      click_button 'Delete Account'

      expect(page).to have_text('Are you sure you want to delete your account? This cannot be undone.')

      click_button 'No'
      expect(User.count).to eq(1)
    end
  end
end
