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
end
