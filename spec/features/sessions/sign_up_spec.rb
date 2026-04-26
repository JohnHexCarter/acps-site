require 'rails_helper'

RSpec.feature 'Sign Up', type: :feature do
  let(:valid_password) { 'AVal1dPassw0rd!!' }
  let(:valid_email) { 'a-good-email@example.com' }

  before do
    visit sign_up_path
  end

  describe 'Unsuccessful Account creation' do
    scenario 'User uses an email that already exists' do
      user = create(:user)

      expect(User.count).to eq(1)

      fill_in 'email_address', with: user.email_address
      fill_in 'password', with: valid_password
      fill_in 'confirm_password', with: valid_password

      click_button 'Create Account'

      expect(page).to have_current_path(sign_up_path(email_address: user.email_address))
      expect(page).to have_content('Something went wrong. Please try again with another email.')

      expect(User.count).to eq(1)
    end

    scenario 'User uses passwords that do not match' do
      expect(User.count).to eq(0)

      fill_in 'email_address', with: valid_email
      fill_in 'password', with: valid_password
      fill_in 'confirm_password', with: 'not a valid password'

      click_button 'Create Account'

      expect(page).to have_current_path(sign_up_path(email_address: valid_email))
      expect(page).to have_content('The passwords do not match. Please try again.')

      expect(User.count).to eq(0)
    end
  end

  describe 'Successful Account creation' do
    before do
      dashboard_setup
    end

    scenario 'User creates an account' do
      expect(User.count).to eq(0)

      fill_in 'email_address', with: valid_email
      fill_in 'password', with: valid_password
      fill_in 'confirm_password', with: valid_password

      click_button 'Create Account'

      expect(page).to have_current_path(dashboard_index_path)
      expect(page).to have_content('Account successfully created')

      expect(User.count).to eq(1)
    end

    scenario 'User had an existing unconfirmed MailingListEntity' do
      mle = create(:mailing_list_entity)

      fill_in 'email_address', with: mle.email
      fill_in 'password', with: valid_password
      fill_in 'confirm_password', with: valid_password

      click_button 'Create Account'

      expect(page).to have_current_path(dashboard_index_path)
      user = User.find_by(email_address: mle.email)
      mle.reload

      expect(mle.archived?).to be(true)
      expect(user.unconfirmed?).to be(true)
    end

    scenario 'User had an existing confirmed MailingListEntity' do
      mle = create(:confirmed_mailing_list_entity)

      fill_in 'email_address', with: mle.email
      fill_in 'password', with: valid_password
      fill_in 'confirm_password', with: valid_password

      click_button 'Create Account'

      expect(page).to have_current_path(dashboard_index_path)
      user = User.find_by(email_address: mle.email)
      mle.reload

      expect(mle.archived?).to be(true)
      expect(user.active?).to be(true)
    end
  end
end
