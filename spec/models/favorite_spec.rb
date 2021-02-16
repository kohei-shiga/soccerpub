require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let(:favorite) { user.favorites.build(article_id: article.id) }
  
  context "when user_id and article_id is presence" do
    it "is valid" do
      expect(favorite).to be_valid
    end
  end
  
  context "when user_id is nil" do
    it "is invalid" do
      favorite.user_id = nil
      expect(favorite).to be_invalid
    end
  end
  
  context "when article_id is nil" do
    it "is invalid" do
      favorite.article_id = nil
      expect(favorite).to be_invalid
    end
  end
end