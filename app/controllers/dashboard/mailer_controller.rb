# frozen_string_literal: true

module Dashboard
  class MailerController < BaseController
    def index
      @confirmed = MailingListEntity.confirmed
    end
  end
end
