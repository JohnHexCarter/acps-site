# frozen_string_literal: true

# id               uuid
# email_address    string, null: false, unique: true
# password_hash    password
# aasm_state       string, null: false, default: 'unverified'
# mailing_list     boolean, null: false, default: false

class User < ApplicationRecord
  include AASM

  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,})   # At least 8 characters long
    (?=.*\d)   # Contains at least one number
    (?=.*[a-z]) # Contains at least one lowercase letter
    (?=.*[A-Z]) # Contains at least one uppercase letter
    (?=.*[[:^alnum:]]) # Contains at least one symbol
  /x.freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :recipients, as: :recipiable
  has_many :mailers, through: :recipients

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :aasm_state, presence: true

  scope :ml_subscribed, -> { where(aasm_status: 'verified', mailing_list: true) }

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

  def attempt_to_set_new_email(new_email)
    old_email = email_address
    self.email_address = new_email

    return false if new_email == old_email || !(self.valid?)

    self.save!

    UserMailer.with(email: old_email, code: id).email_change_from.deliver_now
    UserMailer.with(email: new_email, code: id).email_change_to.deliver_now

    true
  end

  def attempt_to_update_password(old_password:, new_password:)
    potential_user = User.authenticate_by({ email_address: email_address, password: old_password })

    if potential_user.blank? || (potential_user != self)
      return 'Current password was incorrect'
    elsif old_password == new_password
      return 'New password must be different from current password'
    elsif !(new_password =~ PASSWORD_REQUIREMENTS)
      return 'Password is invalid'
    end

    password = new_password

    self.save!

    UserMailer.with(user: self).password_change.deliver_now

    nil
  end

  def complete_destruction
    self.destroy
  end
end
