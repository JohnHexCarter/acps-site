# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def verify
    @user = params[:user]
    @verify_url = "#{site_url}/email-verify/#{@user.id}"
    mail(to: @user.email_address, subject: 'ACPS: Verifying your email')
  end

  def password_change
    @user = params[:user]
    @suspend_url = "#{site_url}/suspicious-report/#{@user.id}?reason='password-change'"
    mail(to: @user.email_address, subject: 'ACPS: Password change notification')
  end

  def suspend_notification
    @user = params[:user]
    @reason = params[:reason]
    mail(to: @user.email_address, subject: 'ACPS: Your account is temporarily suspended')
  end
end
