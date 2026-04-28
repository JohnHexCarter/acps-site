require 'rails_helper'

RSpec.describe Mailer, type: :model do
  describe 'associations' do
    it 'has many recipients' do
      user = create(:user, mailing_list: true, aasm_state: 'active')
      mle = create(:mailing_list_entity, aasm_state: 'confirmed')

      mailer = create(:published_mailer)

      recipent1 = Recipient.create(recipiable: user, mailer: mailer)
      recipient2 = Recipient.create(recipiable: mle, mailer: mailer)

      mailer.reload

      expect(mailer.recipients.count).to eq(2)
      expect(mailer.users.count).to eq(1)
      expect(mailer.mailing_list_entities.count).to eq(1)
    end
  end
end
