# frozen_string_literal: true

module Dashboard
  class MailerController < BaseController
    def index
      @confirmed_mle = MailingListEntity.confirmed
      @mailer_drafts = Mailer.draft
      @mailer_published = Mailer.published
    end

    def new
    end

    def create
      mailer = Mailer.new(subject: params[:subject], body: params[:body])

      if mailer.valid?
        mailer.save!
        redirect_to dashboard_mailer_path, notice: 'You successfully created a new mailer.'
      else
        redirect_to dashboard_new_mailer_path, alert: 'Something went wrong. Please try again.'
      end
    end
  end
end
