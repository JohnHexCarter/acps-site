# frozen_string_literal: true

class SessionsController < ApplicationController
  # turn into an allowlist once we have controllers we don't want to see without authentication
  allow_unauthenticated_access # except: %i[ ]
  rate_limit to: 10, within: 3.minutes, only: %i[create create_user], with: -> { redirect_to new_session_path, alert: 'Try again later.' }

  before_action :check_for_construction, except: %i[new create destroy]

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user.blank?
      redirect_to new_session_path, alert: 'Try another email address or password.'
    elsif user.suspended? || user.banned?
      redirect_to new_session_path, alert: 'That account is currently inaccessible. Contact admin for more information.'
    elsif user = User.authenticate_by(params.permit(:email_address, :password))
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

    user = User.new(email_address: params[:email_address], password: params[:password], aasm_state: 'unverified')

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
