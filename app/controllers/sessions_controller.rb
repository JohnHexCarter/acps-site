# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create sign_up ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: 'Try again later.' }

  before_action :check_for_construction

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: 'Successfully logged in.'
    else
      redirect_to new_session_path, alert: 'Try another email address or password.'
    end
  end

  def sign_up
  end

  def create_user
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other, notice: 'Successfully logged out.'
  end

  def check_for_construction
    redirect_to root_path if @construction
  end
end
