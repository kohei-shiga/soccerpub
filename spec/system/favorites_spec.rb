require 'rails_helper'

RSpec.describe "Favorites", type: :system, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:article) { other_user.articles.create(title: "マンチェスターシティ", content: "試合について") }
  
  context "when user doesn't favorite other_user's article" do
    it "user favorites other_user's article" do
      expect {
        login(user)
        click_link "マンチェスターシティ"
        click_button "Like!"
        expect(page).to have_button "Unlike"
        visit root_path
        click_link "お気に入り"
        expect(page).to have_link "マンチェスターシティ", href: article_path(article)
        visit user_path(user)
        click_link "お気に入り"
        expect(page).to have_link "マンチェスターシティ", href: article_path(article)
      }.to change(user.favorites, :count).by(1)
    end
  end
  
  context "when user favorite other_user's article" do
    before { user.favorite(article) }
    it "user unfavorites other_user's article" do
      expect {
        login(user)
        click_link "マンチェスターシティ"
        click_button "Unlike"
        expect(page).to have_button "Like!"
        visit root_path
        click_link "お気に入り"
        expect(page).to_not have_link "マンチェスターシティ", href: article_path(article)
        visit user_path(user)
        click_link "お気に入り"
        expect(page).to_not have_link "マンチェスターシティ", href: article_path(article)
      }.to change(user.favorites, :count).by(-1)
    end
  end
  
  
end