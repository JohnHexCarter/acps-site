require 'rails_helper'

RSpec.feature 'Index', type: :feature do
  describe 'normal functionality' do
    scenario 'User can see the index page' do
      visit '/'

      expect(page).to have_text('what hath god wrought?')
      expect(page).not_to have_text('Coming soon!')
    end
  end

  describe 'under construction functionality' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:under_construction?).and_return(true)
      allow_any_instance_of(MailingListEntity).to receive(:send_confirmation_email).and_return(true)
    end

    scenario 'sees under construction page' do
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
