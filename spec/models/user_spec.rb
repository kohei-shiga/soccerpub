require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    before do
      @user = User.new(
        name: "Test",
        email: "test@example.com",
        password: "password",
        password_confirmation: "password",
      )
    end
  
    describe "attribute: name" do
      context "when name is present" do
        it "is valid" do
          expect(@user).to be_valid
        end
      end
      context "when name is nil" do
        it "is invalid" do
          @user.name = nil
          expect(@user).to be_invalid
          expect(@user.errors[:name]).to include("can't be blank")
        end
      end
      context "when name is empty" do
        it "is invalid" do
          @user.name = ''
          expect(@user).to be_invalid
          expect(@user.errors[:name]).to include("can't be blank")
        end
      end
      context "when name is space" do
        it "is invalid" do
          @user.name = ' '
          expect(@user).to be_invalid
          expect(@user.errors[:name]).to include("can't be blank")
        end
      end
      context "when name length is 20 characters or less" do
        it "is valid" do
          @user.name = "a" * 20
          expect(@user).to be_valid
        end
      end
      context "when name length is more than 20 characters" do
        it "is invalid" do
          @user.name = "a" * 21
          expect(@user).to be_invalid
        end
      end
    end
    
    describe "attribute: email" do
      context "when email is present" do
        it "is valid" do
          expect(@user).to be_valid
        end
      end
      context "when email is nil" do
        it "is invalid" do
          @user.email = nil
          expect(@user).to be_invalid
          expect(@user.errors[:email]).to include("can't be blank")
        end
      end
      context "when email is empty" do
        it "is invalid" do
          @user.email = ''
          expect(@user).to be_invalid
          expect(@user.errors[:email]).to include("can't be blank")
        end
      end
      context "when email is space" do
        it "is invalid" do
          @user.email = ' '
          expect(@user).to be_invalid
          expect(@user.errors[:email]).to include("can't be blank")
        end
      end
      context "when email length is 255 characters or less" do
        it "is valid" do
          @user.email = 'a' * 243 + '@example.com'
          expect(@user).to be_valid
        end
      end
      context "when email length is more than 255 characters" do
        it "is invalid" do
          @user.email = 'a' * 244 + '@example.com'
          expect(@user).to be_invalid
        end
      end
      context "when email is correct format" do
        it "is valid" do
          expect(@user).to be_valid
        end
      end
      context "when email is incorrect format" do
        it "is invalid" do
          addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
          addresses.each do |invalid_address|
            @user.email = invalid_address
            expect(@user).to be_invalid
          end
        end
      end
      context "when email is already taken" do
        it "is invalid" do
          User.create(
            name: "alice",
            email: "alice@example.com",
            password: "password",
          )
          @user.email = "alice@example.com"
          expect(@user).to be_invalid
        end
      end
      it "is saved in lowercase" do
        @user.email = "Test@Example.Com"
        @user.save
        expect(@user.reload.email).to eq "test@example.com"
      end
    end
    
    describe "attribute: password" do
      context "when password is present" do
        it "is valid" do
          expect(@user).to be_valid
        end
      end
      context "when password is empty" do
        it "is invalid" do
          @user.password = @user.password_confirmation = nil
          expect(@user).to be_invalid
          expect(@user.errors[:password]).to include("can't be blank")
          @user.password = @user.password_confirmation = ''
          expect(@user).to be_invalid
          expect(@user.errors[:password]).to include("can't be blank")
          @user.password = @user.password_confirmation = ' '
          expect(@user).to be_invalid
          expect(@user.errors[:password]).to include("can't be blank")
        end
      end
      context "when password length is less than 7 or more than 21" do
        it "is invalid" do
          @user.password = @user.password_confirmation = "a" * 7
          expect(@user).to be_invalid
          expect(@user.errors[:password]).to include("is too short (minimum is 8 characters)")
          @user.password = @user.password_confirmation = "a" * 21
          expect(@user).to be_invalid
          expect(@user.errors[:password]).to include("is too long (maximum is 20 characters)")
        end
      end
    end
  end
  
  
  describe "follow and unfollow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    before { user.follow(other_user) }
    
    context "when user follow other_user" do
      it "succeeds" do
        expect(user.following?(other_user)).to be true
      end
    end
    context "when user follow own" do
      it "not succeeds" do
        user.follow(user)
        expect(user.following?(user)).to be false
      end
    end
    context "when user unfollow other_user" do
      it "succeeds" do
          user.unfollow(other_user)
          expect(user.following?(other_user)).to be false
        end
    end
    context "when other_user is followed by user" do
      it "succeeds" do
        expect(other_user.followers.include?(user)).to be true
      end
    end
  end
  
  describe "feed" do
    let(:user) { create(:user, :with_articles) }
    let(:other_user) { create(:user, :with_articles) }
    
    context "when user is following other_user" do
      
      before { user.relationships.create!(follow_id: other_user.id) }
      
      it "contains other user's articles in the timeline page" do
        other_user.articles.each do |article|
          expect(user.feed.include?(article)).to be_truthy
        end
      end
      
      it "contains the user's own articles in the timeline page" do
        user.articles.each do |article|
          expect(user.feed.include?(article)).to be_truthy
        end
      end
    end
    
    context "when user is not following other_user" do
      it "doesn't contain other user's articles in the timeline page" do
        other_user.articles.each do |article|
          expect(user.feed.include?(article)).to be_falsy
        end
      end
      it "contains the user's own articles in the timeline page" do
        user.articles.each do |article|
          expect(user.feed.include?(article)).to be_truthy
        end
      end
    end
  end
  
  
end