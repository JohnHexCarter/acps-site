# frozen_string_literal: true

class MailingListMailerPreview < ActionMailer::Preview
  def confirmation
    MailingListMailer.with(mailing_list_entity: MailingListEntity.first).confirmation
  end
end
