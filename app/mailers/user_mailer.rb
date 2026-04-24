# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'john@acpsociety.org'
  layout 'mailer'

  def test_email
    mail(to: 'johnhexcarter@proton.me', subject: 'this is a test')
  end
end
