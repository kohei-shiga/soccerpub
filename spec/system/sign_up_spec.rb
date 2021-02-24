require 'rails_helper'

RSpec.describe "Sign up", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end
  
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http:\/\/localhost:3000\/account_activations\/.*/]
  end
  
  it 'user can sign up correctly' do
    visit root_path
    expect(page).to have_content 'SoccerPubは、サッカーに関する話題を共有し、自分の応援するチームのファンと繋がれるアプリです。'
    
    click_link 'ユーザー登録'
    fill_in 'ユーザー名', with: 'foobar'
    fill_in 'メールアドレス', with: 'foobar@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in '確認', with: 'password'
    expect { click_button '登録する' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'アカウントを有効化するため、メールをご確認ください。'
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content 'アカウントが有効化されました。'
  end
end