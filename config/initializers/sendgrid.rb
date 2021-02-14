require './lib/mail/send_grid'

ActionMailer::Base.add_delivery_method :sendgrid, Mail::SendGrid,
  api_key: ENV['SENDGRID_API_KEY']
  