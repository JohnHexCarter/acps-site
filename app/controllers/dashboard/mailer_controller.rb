# frozen_string_literal: true

module Dashboard
  class MailerController < BaseController
    def index
      @confirmed_mle = MailingListEntity.confirmed
      @mailer_drafts = Mailer.draft
      @mailer_published = Mailer.published
    end
  end
end
