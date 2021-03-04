require 'rails_helper'

RSpec.describe "Articles", type: :system, js: true do
  let(:user) { create(:user) }
  
  it "user post article" do
    expect {
      login(user)
      click_link '投稿する'
      fill_in 'タイトル', with: 'シティー対リバプール'
      fill_in 'タグ', with: 'マンチェスターシティ'
      fill_in_rich_text_area 'article_content', with: 'マンチェスターシティの勝利'
      click_button '投稿する'
    }.to change(user.articles, :count).by(1)

    expect(page).to have_content '記事を投稿しました。'
    click_link 'シティー対リバプール'
    expect(page).to have_content 'マンチェスターシティ'
    expect(page).to have_content 'マンチェスターシティの勝利'
    visit user_path(user)
    expect(page).to have_content 'シティー対リバプール'
    
  end
  
end