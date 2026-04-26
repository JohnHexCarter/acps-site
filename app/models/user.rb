# frozen_string_literal: true

# id               uuid
# email_address    string, null: false, unique: true
# password_hash    password
# aasm_state       string, null: false, default: 'unverified'
# mailing_list     boolean, null: false, default: false

class User < ApplicationRecord
  include AASM

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :aasm_state, presence: true

  aasm do
    state :unverified, initial: true
    state :active, :suspended, :banned

    event :verify do
      transitions from: :unverified, to: :active
    end

    event :suspend do
      transitions from: %i[unverified active], to: :suspended
    end

    event :ban do
      transitions from: %i[unverified active suspended], to: :banned
    end

    event :reactivate do
      transitions from: :suspended, to: :active
    end

    event :unban do
      transitions from: :banned, to: :active
    end

    event :revert_to_unverified do
      transitions from: %i[suspended banned], to: :unverified
    end
  end

  def hidden_email
    email_array = email_address.split('@')

    "#{email_array[0][0..2]}...@#{email_array[1]}"
  end

  def suspend_for_suspicious_activity(reason)
    session = self.sessions.last
    session.destroy if session.present?

    return unless self.may_suspend?

    self.suspend!

    UserMailer.with(user: self, reason: reason).suspend_notification.deliver_now
  end

  def update_password(new_password)
    password = new_password

    self.save!

    UserMailer.with(user: self).password_change.deliver_now
  end

  def complete_destruction
    self.destroy
  end
end
