require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { build(:user) }

  describe 'validations' do
    it 'requires an email_address to be valid' do
      subject.email_address = nil

      expect(subject).not_to be_valid
    end

    it 'requires an email_address to be unique' do
      user = create(:user)
      subject.email_address = user.email_address

      expect(subject).not_to be_valid
    end

    it 'requires a valid email_address to be valid' do
      subject.email_address = 'not an email address'

      expect(subject).not_to be_valid
    end

    it 'requires an aasm_state to be valid' do
      subject.aasm_state = nil

      expect(subject).not_to be_valid
    end
  end

  describe 'complete_destruction' do
    let(:subject) { create(:user) }

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
