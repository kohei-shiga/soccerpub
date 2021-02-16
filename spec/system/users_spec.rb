require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "Authorization" do
    let(:user) { create(:user) }
    
    context "when user not logged in" do
      it "redirects followings" do
        visit followings_user_path(user)
        expect(page).to have_content 'SoccerPubにログイン'
      end
    end
    context "when user not logged in" do
      it "redirects followers" do
        visit followers_user_path(user)
        expect(page).to have_content 'SoccerPubにログイン'
      end
    end
  end
end