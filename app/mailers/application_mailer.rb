class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@acpsociety.org'
  layout 'mailer'

  def site_url
    ENV['URL']
  end
end
