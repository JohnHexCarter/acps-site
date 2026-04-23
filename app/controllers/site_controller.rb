# frozen_string_literal: true

class SiteController < ApplicationController
  allow_unauthenticated_access

  layout :check_for_dummy_page

  def index
  end

  def check_for_dummy_page
    @dummy ? 'dummy' : 'application'
  end

  def email_signup
    MailingListEntity.try_to_sign_up(email: params[:email_address])

    redirect_to root_path, notice: 'If that email is not already in our system, you should receive a confirmation email soon.'
  end
end
