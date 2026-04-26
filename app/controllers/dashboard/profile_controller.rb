# frozen_string_literal: true

module Dashboard
  class ProfileController < BaseController
    def index
      @unverified = current_user.unverified?
    end

    def update_email
      # validate email on server side
      current_user.email_address = params[:email_address]

      if current_user.valid? && current_user.email_address != params[:email_address]
        current_user.save!

        flash[:notice] = 'Successfully changed email'
      else
        flash[:alert] = 'Something went wrong. Please try again.'
      end

      redirect_to dashboard_profile_path
    end

    def update_password
      potential_user =
        User.authenticate_by(
          {
            email_address: current_user.email_address,
            password: params[:current_password]
          }
        )
      if potential_user == current_user &&
         params[:new_password] == params[:confirm_password] &&
         params[:current_password] != params[:new_password]
        current_user.password = params[:new_password]
        flash[:notice] = 'Successfully changed password.'
      else
        flash[:alert] = 'Something went wrong. Please try again.'
      end

      redirect_to dashboard_profile_path
    end

    def destroy
      user = current_user

      user.complete_destruction

      terminate_session
      redirect_to root_path, notice: 'Successfully deleted account.'
    end

    def send_verification
      UserMailer.with(user: current_user).verify.deliver_now

      redirect_to dashboard_profile_path, notice: 'A verification has been sent to your email address.'
    end

    def email_verification
      user = User.find params[:code]

      unless user.may_verify?
        redirect_to root_path, alert: 'Something went wrong. Please contact a member of the ACPS site.'
      end

      user.verify!

      redirect_to dashboard_profile_path, notice: 'Your email has been successfully verified.'
    end
  end
end
