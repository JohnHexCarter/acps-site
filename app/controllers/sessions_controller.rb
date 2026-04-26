# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create sign_up create_user ]
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
    @email_address = params[:email_address].present? ? params[:email_address] : nil
  end

  def create_user
    if User.find_by(email_address: params[:email_address]).present?
      redirect_to sign_up_path(email_address: params[:email_address]), alert: 'Something went wrong. Please try again with another email.'
      return
    end

    if params[:password] != params[:confirm_password]
      redirect_to sign_up_path(email_address: params[:email_address]), alert: 'The passwords do not match. Please try again.'
      return
    end

    user = User.new(email_address: params[:email_address], password: params[:password], aasm_state: 'unconfirmed')

    unless user.valid?
      redirect_to sign_up_path(email_address: params[:email_address]), alert: 'Something went wrong. Please try again with another email.'
      return
    end

    user.save!

    MailingListEntity.check_to_migrate(user: user)

    user = User.authenticate_by({ email_address: params[:email_address], password: params[:password] })
    start_new_session_for user

   redirect_to dashboard_index_path, notice: 'Account successfully created.'
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other, notice: 'Successfully logged out.'
  end

  def check_for_construction
    redirect_to root_path if @construction
  end
end
