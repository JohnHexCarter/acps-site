# frozen_string_literal: true

# id         id
# email      string, null: false
# aasm_state string, null: false, default: 'unconfirmed'

class MailingListEntity < ApplicationRecord
  include AASM

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :aasm_state, presence: true

  after_create :send_confirmation_email

  aasm do
    state :unconfirmed, initial: true
    state :confirmed, :archived

    event :confirm do
      transitions from: :unconfirmed, to: :confirmed
    end

    event :archive do
      transitions from: %i[confirmed unconfirmed], to: :archived
    end
  end

  def self.try_to_sign_up(email:)
    mle = MailingListEntity.new(email: email)

    mle.save! if mle.valid?
  end

  def send_confirmation_email
    MailingListMailer.with(mailing_list_entity: self).confirmation.deliver_now
  end
end
