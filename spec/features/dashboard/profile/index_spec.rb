require 'rails_helper'

RSpec.feature 'Dashboard Profile Index', type: :feature do
  let(:password) { 'P@ssw0rd!!' }
  let!(:user) { create(:user, email_address: 'test@example.com', password: password) }

  before do
    dashboard_setup
    login_with(user.email_address, password)

    allow_any_instance_of(ApplicationController).to receive(:set_construction).and_return(false)
  end

  scenario 'User can see profile page' do
    visit dashboard_profile_path

    expect(page).to have_text('User Profile')
  end

  scenario 'User can see the profile link in the sidebar' do
    visit dashboard_index_path

    expect(page).to have_css('div#dashboard-sidebar')
  end

  describe 'Email Management' do
    context 'with an unverified user' do
      before do
        visit dashboard_profile_path
      end

      scenario 'User cannot change their email while unverified' do
        expect(page).to have_field 'email_address', disabled: true
      end
    end

    context 'with a verified user' do
      before do
        user.verify!
        visit dashboard_profile_path
      end

      scenario 'User successfully changes their email' do
        fill_in 'email_address', with: 'anotherTest@example.com'
        click_button 'Set New Email'

        expect(page).to have_content('Successfully changed email')
        expect(page).not_to have_content('Something went wrong. Please try again.')
      end

      scenario 'User accidentally tries to change to same email' do
        fill_in 'email_address', with: user.email_address
        click_button 'Set New Email'

        expect(page).not_to have_content('Successfully changed email')
        expect(page).to have_content('Something went wrong. Please try again.')
      end

      scenario 'User tries to save an invalid email' do
        allow(user).to receive(:valid?).and_return(false)

        fill_in 'email_address', with: 'not-a-valid-email'
        click_button 'Set New Email'

        expect(page).not_to have_content('Successfully changed email')
        expect(page).to have_content('Something went wrong. Please try again.')
      end
    end
  end

  describe 'Password Management' do
    context 'with an unverified user' do
      before do
        visit dashboard_profile_path
      end

      scenario 'User should not be able to edit password fields' do
        expect(page).to have_field 'current_password', disabled: true
        expect(page).to have_field 'new_password', disabled: true
        expect(page).to have_field 'confirm_password', disabled: true
      end
    end

    context 'with a verified user' do
      let(:new_password) { 'P@ssw1rd!!' }

      before do
        user.verify!
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
        expect(page).to have_content('New password must be different from current password')
      end

      scenario 'User puts in wrong password for current password' do
        fill_in 'current_password', with: 'Not the password'
        fill_in 'new_password', with: new_password
        fill_in 'confirm_password', with: new_password

        click_button 'Set New Password'

        expect(page).not_to have_content('Successfully changed password')
        expect(page).to have_content('Current password was incorrect')
      end

      scenario 'User doesn\'t repeat new password for confirm password' do
        fill_in 'current_password', with: password
        fill_in 'new_password', with: new_password
        fill_in 'confirm_password', with: "#{new_password}!!"

        click_button 'Set New Password'

        expect(page).not_to have_content('Successfully changed password')
        expect(page).to have_content('New Password and Confirm Password do not match')
      end

      scenario 'User chooses an invalid password for new password' do
        fill_in 'current_password', with: password
        fill_in 'new_password', with: 'invalid'
        fill_in 'confirm_password', with: 'invalid'

        click_button 'Set New Password'

        expect(page).not_to have_content('Successfully changed password')
        expect(page).to have_content('Password is invalid')
      end
    end
  end

  describe 'Account Deletion' do
    before do
      visit dashboard_profile_path
    end

    scenario 'User wants to delete their account' do
      expect(User.count).to eq(1)
      email_address = user.email_address

      click_button 'Delete Account'

      click_button 'Yes'

      expect(page).to have_current_path(root_path)

      click_link 'Log In'

      fill_in 'email_address', with: email_address
      fill_in 'password', with: password

      click_button 'Log in'

      expect(page).to have_current_path(new_session_path)
      expect(page).to have_content('Try another email address or password.')
      expect(User.count).to eq(0)
    end

    scenario 'User changes mind while deleting their account' do
      expect(User.count).to eq(1)
      click_button 'Delete Account'

      expect(page).to have_text('Are you sure you want to delete your account? This cannot be undone.')

      click_button 'No'
      expect(User.count).to eq(1)
    end
  end
end
