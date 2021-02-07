require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "validation" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.relationships.build(follow_id: other_user.id) }
    
    context "when user_id and follow_id is presence" do
      it "is valid" do
        expect(relationship).to be_valid
      end
    end
    context "when user_id is nil" do
      it "is invalid" do
        relationship.user_id = nil
        expect(relationship).to be_invalid
      end
    end
    context "when follow_id is nil" do
      it "is invalid" do
        relationship.follow_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end
