class MailingListMailer < ApplicationMailer
  def confirmation
    @mailing_list_entity = params[:mailing_list_entity]
    @confirm_url = "#{ENV['URL']}/confirm/#{@mailing_list_entity.id}"
    mail(to: @mailing_list_entity.email, subject: 'Welcome to the ACPS Mailing List!')
  end
end
