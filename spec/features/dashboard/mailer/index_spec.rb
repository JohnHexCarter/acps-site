require 'rails_helper'

RSpec.feature 'Mailer Index', type: :feature do
  before do
    dashboard_setup
    login
  end

  context 'viewing Mailing List Entites on index' do
    scenario 'an MLE with a confirmed status will show up' do
      mle = create(:confirmed_mailing_list_entity)

      visit dashboard_mailer_path

      expect(page).to have_content(mle.email)
    end

    scenario 'an MLE with an unconfirmed status will not show up' do
      mle = create(:mailing_list_entity, aasm_state: 'unconfirmed')

      visit dashboard_mailer_path

      expect(page).not_to have_content(mle.email)
    end

    scenario 'an MLE with an archvied status will not show up' do
      mle = create(:mailing_list_entity, aasm_state: 'archived')

      visit dashboard_mailer_path

      expect(page).not_to have_content(mle.email)
    end
  end
end
