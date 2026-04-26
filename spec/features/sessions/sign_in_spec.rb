require 'rails_helper'

RSpec.feature 'Sign In', type: :feature do
  let(:password) { 'P@ssw0rd!!' }

  before do
    dashboard_setup
  end

  scenario 'User can log in' do
    user = create(:user, password: password)

    visit new_session_path

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: password

    click_button 'Log in'

    expect(page).to have_current_path(dashboard_index_path)
    expect(page).to have_content('Successfully logged in')
  end

  scenario 'User is suspended and cannot log in' do
    user = create(:suspended_user, password: password)

    visit new_session_path

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: password

    click_button 'Log in'

    expect(page).to have_current_path(new_session_path)
    expect(page).to have_content('That account is currently inaccessible.')
  end

  scenario 'User is banned and cannot log in' do
    user = create(:banned_user, password: password)

    visit new_session_path

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: password

    click_button 'Log in'

    expect(page).to have_current_path(new_session_path)
    expect(page).to have_content('That account is currently inaccessible.')
  end
end
