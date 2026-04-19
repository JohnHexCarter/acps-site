require 'rails_helper'

RSpec.feature 'Index', type: :feature do
  scenario 'User can see the index page' do
    visit '/'

    expect(page).to have_text('what hath god wrought?')
  end

  scenario 'User can login' do
    password = 'P@ssw0rd!'
    user = create(:user)
    user.password = password
    user.save

    visit '/'

    expect(page).not_to have_text("Welcome, #{user.email_address}")

    click_link 'Log In'

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: password

    click_button 'Sign in'

    expect(page).to have_current_path(dashboard_index_path)
    expect(page).to have_text("Welcome, #{user.email_address}")
  end
end
