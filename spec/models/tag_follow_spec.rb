require 'rails_helper'

RSpec.describe TagMap, type: :model do
  describe "validation" do
    let(:user) { create(:user) }
    let(:tag) { create(:tag) }
    let(:tag_follow) { user.tag_follows.build(tag_id: tag.id) }
    
    context "when user_id and tag_id is presence" do
      it "is valid" do
        expect(tag_follow).to be_valid
      end
    end
    context "when user_id is nil" do
      it "is invalid" do
        tag_follow.user_id = nil
        expect(tag_follow).to be_invalid
      end
    end
    context "when tag_id is nil" do
      it "is valid" do
        tag_follow.tag_id = nil
        expect(tag_follow).to be_invalid
      end
    end
  end
  
  
end