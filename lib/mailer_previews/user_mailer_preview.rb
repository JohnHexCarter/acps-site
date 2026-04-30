# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def verify
    UserMailer.with(user: User.first).verify
  end

  def email_change_from
    user = User.first
    UserMailer.with(email: user.email_address, code: user.id).email_change_from
  end

  def email_change_to
    user = User.first
    UserMailer.with(email: user.email_address, code: user.id).email_change_to
  end

  def password_change
    UserMailer.with(user: User.first).password_change
  end

  def suspend_notification
    UserMailer.with(user: User.first, reason: 'password-change').suspend_notification
  end
end
