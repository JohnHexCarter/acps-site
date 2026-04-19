require 'rails_helper'

RSpec.feature 'Dashboard Profile Index', type: :feature do
  let(:password) { 'P@ssw0rd!!' }
  let(:user) { create(:user, email_address: 'test@example.com', password: password) }

  before do
    dashboard_setup
    login_with(user.email_address, password)
  end

  scenario 'User can see profile page' do
    visit dashboard_profile_index_path

    expect(page).to have_text('profile settings for days, yo')
  end

  scenario 'User can see the profile link in the sidebar' do
    visit dashboard_index_path

    expect(page).to have_css('div#dashboard-sidebar')
  end
end
