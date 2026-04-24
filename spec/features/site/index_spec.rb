require 'rails_helper'

RSpec.feature 'Index', type: :feature do
  before do
    dashboard_setup
  end

  describe 'normal functionality' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:set_dummy).and_return(false)
    end

    scenario 'User can see the index page' do
      visit '/'

      expect(page).to have_text('what hath god wrought?')
      expect(page).not_to have_text('Coming soon!')
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
    end
  end

  describe 'dummy functionality' do
    before do
      allow_any_instance_of(MailingListEntity).to receive(:send_confirmation_email).and_return(true)
    end

    scenario 'sees dummy page' do
      visit '/'

      expect(page).not_to have_text('what hath god wrought?')
      expect(page).to have_text('Coming soon!')
    end

    scenario 'filling in the email form creates a MailingListEntity' do
      expect(MailingListEntity.count).to eq(0)

      visit '/'

      fill_in 'email_address', with: 'valid@gmail.com'

      click_button 'Sign me up!'

      expect(page).to have_text('If that email is not already in our system, you should receive a confirmation email soon.')
      expect(MailingListEntity.count).to eq(1)
    end

    scenario 'filling in the email form with an invalid email won\'t error' do
      expect(MailingListEntity.count).to eq(0)

      visit '/'

      fill_in 'email_address', with: 'not-a-valid-anything'

      click_button 'Sign me up!'

      expect(page).to have_text('If that email is not already in our system, you should receive a confirmation email soon.')
      expect(MailingListEntity.count).to eq(0)
    end
  end
end
