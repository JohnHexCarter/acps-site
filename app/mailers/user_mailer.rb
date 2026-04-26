# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def verify
    @user = params[:user]
    @verify_url = "#{site_url}/email-verify/#{@user.id}"
    mail(to: @user.email_address, subject: 'ACPS: Verifying your email')
  end
end
