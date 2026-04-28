require 'rails_helper'

RSpec.describe MailingListEntity, type: :model do
  let(:valid_email) { 'valid@gmail.com' }
  let(:subject) { build(:mailing_list_entity, email: valid_email) }

  before do
    allow_any_instance_of(MailingListEntity).to receive(:send_confirmation_email).and_return(true)
  end

  describe 'associations' do
    it 'has a relationship to mailers' do
      mailer = create(:mailer)

      mle = create(:confirmed_mailing_list_entity)

      Recipient.create(mailer: mailer, recipiable: mle)

      expect(mle.mailers.count).to eq(1)
      expect(mle.mailers.first).to eq(mailer)
    end
  end

  describe 'validations' do
    it 'must have an email' do
      subject.email = nil

      expect(subject).not_to be_valid
    end

    it 'must have a unique email' do
      mle = create(:mailing_list_entity, email: valid_email)

      subject.email = valid_email

      expect(subject).not_to be_valid
    end

    it 'must have an aasm_state' do
      subject.aasm_state = nil

      expect(subject).not_to be_valid
    end
  end

  describe '#try_to_sign_up' do
    it 'will not create an MLE if the email is invalid' do
      expect(MailingListEntity.count).to eq(0)

      MailingListEntity.try_to_sign_up(email: 'an-invalid-email')

      expect(MailingListEntity.count).to eq(0)
    end

    it 'will not create an MLE if the email is already in the system' do
      mle = create(:mailing_list_entity, email: valid_email)

      expect(MailingListEntity.count).to eq(1)

      MailingListEntity.try_to_sign_up(email: valid_email)

      expect(MailingListEntity.count).to eq(1)
    end

    it 'will create an MLE if the email is valid and not in the system' do
      expect(MailingListEntity.count).to eq(0)

      MailingListEntity.try_to_sign_up(email: valid_email)

      expect(MailingListEntity.count).to eq(1)
    end
  end
end
