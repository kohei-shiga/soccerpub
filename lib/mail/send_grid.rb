require 'sendgrid-ruby'

class Mail::SendGrid
  include SendGrid

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    from = SendGrid::Email.new(email: mail.from.first)
    to = SendGrid::Email.new(email: mail.to.first)
    subject = mail.subject
    content = SendGrid::Content.new(type: 'text/plain', value: mail.body.parts[0].body.raw_source)
    sg_mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: @settings[:api_key])
    response = sg.client.mail._('send').post(request_body: sg_mail.to_json)
    Rails.logger.debug response.status_code
  end
end