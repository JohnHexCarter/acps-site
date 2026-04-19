require 'rails_helper'

RSpec.feature 'Dashboard Index', type: :feature do
  scenario 'User must be logged in to see' do
    visit dashboard_index_path

    expect(page).not_to have_current_path(dashboard_index_path)
    expect(page).to have_current_path(new_session_path)
  end

  scenario 'User can see dashboard when logged in' do
    user = create(:user)
    password = 'P@ssw0rd!!'
    user.password = password
    user.save

    visit new_session_path

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: password

    click_button 'Sign in'

    expect(page).to have_current_path(dashboard_index_path)
    expect(page).to have_text('you best be believin\' in dashboards')
  end
end
