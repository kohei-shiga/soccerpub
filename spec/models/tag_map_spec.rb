require 'rails_helper'

RSpec.describe TagMap, type: :model do
  describe "validation" do
    let(:article) { create(:article) }
    let(:tag) { create(:tag) }
    let(:tag_map) { tag.tag_maps.build(article_id: article.id) }
    
    context "when tag_id and article_id is presence" do
      it "is valid" do
        expect(tag_map).to be_valid
      end
    end
    context "when tag_id is nil" do
      it "is invalid" do
        tag_map.tag_id = nil
        expect(tag_map).to be_invalid
      end
    end
    context "when article_id is nil" do
      it "is valid" do
        tag_map.article_id = nil
        expect(tag_map).to be_invalid
      end
    end
  end
  
  
end