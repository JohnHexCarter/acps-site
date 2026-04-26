# frozen_string_literal: true

# id               uuid
# email_address    string, null: false, unique: true
# password_hash    password
# aasm_state       string, null: false, default: 'unconfirmed'
# mailing_list     boolean, null: false, default: false

class User < ApplicationRecord
  include AASM

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :aasm_state, presence: true

  aasm do
    state :unconfirmed, initial: true
    state :active, :suspended, :banned

    event :confirm do
      transitions from: :unconfirmed, to: :active
    end

    event :suspend do
      transitions from: %i[unconfirmed active], to: :suspended
    end

    event :ban do
      transitions from: %i[unconfirmed active suspended], to: :banned
    end

    event :reactivate do
      transitions from: :suspended, to: :active
    end

    event :unban do
      transitions from: :banned, to: :active
    end

    event :revert_to_unconfirmed do
      transitions from: %i[suspended banned], to: :unconfirmed
    end
  end

  def complete_destruction
    self.destroy
  end
end
