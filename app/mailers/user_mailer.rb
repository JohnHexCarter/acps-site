# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_change_from
    @suspend_url = suspend_url(code: params[:code], reason: 'email-change')
    mail(to: params[:email], subject: 'ACPS: An email address change was made')
  end

  def email_change_to
    @suspend_url = suspend_url(code: params[:code], reason: 'email-change')
    mail(to: params[:email], subject: 'ACPS: An email address change was made')
  end

  def verify
    @user = params[:user]
    @verify_url = "#{site_url}/email-verify/#{@user.id}"
    mail(to: @user.email_address, subject: 'ACPS: Verifying your email')
  end

  def password_change
    @user = params[:user]
    @suspend_url = suspend_url(code: @user.id, reason: 'password-change')
    mail(to: @user.email_address, subject: 'ACPS: Password change notification')
  end

  def suspend_notification
    @user = params[:user]
    @reason = params[:reason]
    mail(to: @user.email_address, subject: 'ACPS: Your account is temporarily suspended')
  end

  def suspend_url(code:, reason:)
    "#{site_url}/suspicious-report/#{code}?reason='#{reason}'"
  end
end
