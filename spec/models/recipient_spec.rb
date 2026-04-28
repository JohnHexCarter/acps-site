require 'rails_helper'

RSpec.describe Recipient, type: :model do
  describe 'associations' do
    it 'can belong to a user' do
      user = build(:user)
      recipient = Recipient.new(recipiable: user)

      expect(recipient.recipiable).to eq(user)
    end

    it 'can belong to a mailing list entity' do
      mle = build(:mailing_list_entity)
      recipient = Recipient.new(recipiable: mle)

      expect(recipient.recipiable).to eq(mle)
    end
  end
end
