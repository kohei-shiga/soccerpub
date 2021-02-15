require 'rails_helper'

RSpec.describe "Followings", type: :system, js: true do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 20) }
  
  before do
    other_users[0..9].each do |other_user|
      user.relationships.create!(follow_id: other_user.id)
      user.reverses_of_relationship.create!(user_id: other_user.id)
    end
    login(user)
  end
  
  it "The number of followings is correct" do
    visit user_path(user)
    click_on "フォロー"
    expect(user.followings.count).to eq 10
    user.followings.each do |following|
      expect(page).to have_link following.name, href: user_path(following)
    end
  end
  it "The number of followers is correct" do
    visit user_path(user)
    click_on "フォロワー"
    expect(user.followers.count).to eq 10
    user.followers.each do |follower|
      expect(page).to have_link follower.name, href: user_path(follower)
    end
  end
  
  context "when user clicks on Unfollow" do
    it "the number of followings increase by -1" do
      expect {
        visit user_path(other_users.first.id)
        click_on "フォローを外す"
        expect(page).to have_button "フォローする"
      }.to change(user.followings, :count).by(-1)
    end
  end
  
  context "when user clicks on Follow" do
    it "the number of followings increase by 1" do
      expect {
        visit user_path(other_users.last.id)
        click_on "フォローする"
        expect(page).to have_button "フォローを外す"
      }.to change(user.followings, :count).by(1)
    end
  end
  
end