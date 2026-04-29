# frozen_string_literal: true

module Dashboard
  class MailerController < BaseController
    before_action :fetch_mailer, only: %i[ view edit update ]

    def index
      @confirmed_mle = MailingListEntity.confirmed
      @mailer_drafts = Mailer.draft
      @mailer_published = Mailer.published
    end

    def view
    end

    def edit
    end

    def update
      @mailer.subject = params[:mailer][:subject]
      @mailer.body = params[:mailer][:body]

      if @mailer.valid?
        @mailer.save!
        redirect_to dashboard_mailer_path, notice: 'Successfully updated mailer'
      else
        redirect_to dashboard_edit_mailer_path(id: @mailer.id), alert: 'Something went wrong. Please try again.'
      end
    end

    def new
    end

    def create
      mailer = Mailer.new(subject: params[:subject], body: params[:body])

      if mailer.valid?
        mailer.save!
        redirect_to dashboard_mailer_path, notice: 'Successfully created a new mailer.'
      else
        redirect_to dashboard_new_mailer_path, alert: 'Something went wrong. Please try again.'
      end
    end

    private

    def fetch_mailer
      @mailer = Mailer.find params[:id]
    end
  end
end
