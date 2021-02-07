require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  
  describe "account_activation" do
  end
  
  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }
    
    it "renders the headers" do
      user.reset_token = User.new_token
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["soccerpub@example.com"]
      expect(mail.subject).to eq "パスワードの再設定"
    end
    
    it "renders the body" do
      user.reset_token = User.new_token
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end