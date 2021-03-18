require './lib/mail/send_grid'

ActionMailer::Base.add_delivery_method :sendgrid, Mail::SendGrid,
  api_key: Rails.application.credentials.sendgrid_api_key
  