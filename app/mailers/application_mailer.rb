class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@acpsociety.org'
  layout 'mailer'

  # before_action :header_logo

  def header_logo
    file = File.open(Rails.root.join('app', 'assets', 'images', 'primary-transparent.png'), 'rb')
    attachments.inline['primary-transparent.png'] = file.read
  end

  def site_url
    ENV['URL']
  end
end
