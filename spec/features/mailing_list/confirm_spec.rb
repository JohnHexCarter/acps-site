require 'rails_helper'

RSpec.feature 'Confirm Mailing List', type: :feature do
  before do
    allow_any_instance_of(MailingListEntity).to receive(:send_confirmation_email).and_return(true)
  end

  let(:mle) { create(:mailing_list_entity) }

  scenario 'Confirming a Mailing List' do
    visit "/confirm/#{mle.id}"

    expect(mle.confirmed?).to eq(false)

    expect(page).to have_content('Please click here to confirm you\'d like to join our Mailing List')

    click_on('Please click here to confirm you\'d like to join our Mailing List')

    expect(page).to have_current_path(root_url)
    expect(page).to have_content('You are now confirmed for our mailing list')

    mle.reload

    expect(mle.confirmed?).to eq(true)
  end
end
