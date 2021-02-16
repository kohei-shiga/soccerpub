require 'rails_helper'

RSpec.describe "Favorites", type: :system, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:article) { create(:article, user: other_user) }
  let(:tag) { Tag.create(name: "マンチェスターシティ") }
  
  before { tag.tag_maps.create(article_id: article.id) }
  
  context "when user tag_follow other_user article's tag" do
    it "succeeds" do
      expect {
        login(user)
        click_link "マンチェスターシティ"
        click_button "記事をフォローする"
        visit root_path
        click_link "タグ"
        expect(page).to have_link "マンチェスターシティ", href: tag_path(tag)
      }.to change(user.tag_follows, :count).by(1)
    end
  end
    
  context "when user cancel tag_follow other_user article's tag" do
    before { user.tag_follows.create(tag_id: tag.id) }
    it "succeeds" do
      expect {
        login(user)
        click_link "マンチェスターシティ"
        click_button "記事のフォローを外す"
        visit root_path
        click_link "タグ"
        expect(page).to_not have_link "マンチェスターシティ", href: tag_path(tag)
      }.to change(user.tag_follows, :count).by(-1)
    end
  end
end