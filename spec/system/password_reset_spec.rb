require 'rails_helper'

RSpec.describe "Password_reset", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
    @user = create(:user, email: "passwordreset@example.com", password: "password")
    login(@user)
  end
  
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http:\/\/localhost:3000\/password_resets\/.*/]
  end
  
  it 'user can reset password correctly' do
    
    visit user_path(@user)
    click_link 'プロフィールを編集する'
    click_link 'パスワードの変更はこちらから'
    fill_in 'メールアドレス', with: 'passwordreset@example.com'
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'パスワード再設定用のメールを送りました。'
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content 'パスワード再設定'
    fill_in 'パスワード', with: 'newpassword'
    fill_in '確認', with: 'newpassword'
    click_button 'パスワードを更新する'
    expect(page).to have_content 'パスワードの再設定を完了しました。'

  end
end