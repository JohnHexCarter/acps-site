require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { create(:user) }

  describe 'validations' do
    it 'requires an email_address to be valid' do
      subject.email_address = nil

      expect(subject).not_to be_valid
    end

    it 'requires an email_address to be unique' do
      new_subject = build(:user, email_address: subject.email_address)

      expect(new_subject).not_to be_valid
    end
  end

  describe 'complete_destruction' do
    it 'destroys the user' do
      expect(subject).to be_valid
      expect(User.count).to eq(1)

      subject.complete_destruction

      expect(User.count).to eq(0)
    end

    it 'destroys all sessions connected to the user' do
      session = Session.create(user: subject)

      expect(Session.count).to eq(1)

      subject.complete_destruction

      expect(Session.count).to eq(0)
    end
  end
end
