# frozen_string_literal: true

module Dashboard
  class ProfileController < BaseController
    def index
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
  end
end
