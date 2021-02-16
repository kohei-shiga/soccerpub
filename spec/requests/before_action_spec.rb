require 'rails_helper'

RSpec.describe "Before_Action", type: :request do
  context "when user not logged in" do
    
    context "user create relationship" do
      let(:post_request) { post relationships_path }
      
      it "doesn't change Relationship's count" do
        expect { post_request }.to change(Relationship, :count).by(0)
      end
      it "redirect to login url" do
        expect(post_request).to redirect_to login_url
      end
    end
    
    context "user destroy relationship" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:delete_request) { delete relationship_path(other_user) }
      
      before { user.followings << other_user }
      
      it "doesn't change Relationship's count" do
        expect { delete_request }.to change(Relationship, :count).by(0)
      end
       it "redirect to login url" do
        expect(delete_request).to redirect_to login_url
      end
    end
  end
end