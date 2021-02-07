require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "Authorization" do
    let(:user) { create(:user) }
    
    context "when user not logged in" do
      it "redirects followings" do
        get followings_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
    context "when user not logged in" do
      it "redirects followers" do
        get followers_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
  end
end
