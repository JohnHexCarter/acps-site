# frozen_string_literal: true

module Dashboard
  class MailerController < BaseController
    def index
      @confirmed = MailingListEntity.confirmed
    end

    def new
    end

    def create
      mailer = Mailer.new params.expect(mailer: [:subject, :body])

      if mailer.valid?
        redirect_to dashboard_mailer_path, notice: 'You successfully created a new mailer.'
      else
        redirect_to dashboard_new_mailer_path, alert: 'Something went wrong. Please try again.'
      end
    end
  end
end
