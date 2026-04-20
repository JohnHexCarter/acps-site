# frozen_string_literal: true

module Dashboard
  class ProfileController < BaseController
    def index
    end

    def destroy
      user = current_user

      user.complete_destruction

      terminate_session
      redirect_to root_path
    end
  end
end
