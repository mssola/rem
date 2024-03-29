require 'spec_helper'

describe User do
  describe '#send_password_reset' do
    let(:user) { Factory(:user) }

    it 'generates a unique password_reset_token' do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it 'saves the time the password reset was sent' do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it 'delivers email to user' do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  describe "relationships" do
    let(:user) { Factory(:user) }
    before(:each) { @followed = Factory(:user) }

    it "should have a relationships method" do
      user.should respond_to(:relationships)
    end

    it "should have a following method" do
      user.should respond_to(:following)
    end

    it "should follow another user" do
      user.follow!(@followed)
      user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      user.follow!(@followed)
      user.following.should include(@followed)
    end

    it "should unfollow a user" do
      user.follow!(@followed)
      user.unfollow!(@followed)
      user.should_not be_following(@followed)
    end

    it "should have a reverse_relationships method" do
      user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      user.follow!(@followed)
      @followed.followers.should include(user)
    end
  end

  describe 'route relationships' do
    let(:user) { Factory(:user) }
    before(:each) { @followed = Factory(:route) }

    it "should have a route_relationships method" do
      user.should respond_to(:route_relationships)
    end

    it "should have a route_following method" do
      user.should respond_to(:route_following)
    end

    it "should follow route" do
      user.follow!(@followed)
      user.should be_following(@followed)
    end
  end
end
