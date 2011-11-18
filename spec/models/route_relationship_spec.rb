require 'spec_helper'

describe RouteRelationship do
  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:route)
    @rsh = @follower.route_relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @rsh.save!
  end

  describe "follow methods" do
    before(:each) { @rsh.save }

    it "should have a follower attribute" do
      @rsh.should respond_to(:follower)
    end

    it "should have the right follower" do
      @rsh.follower.should == @follower
    end

    it "should have a followed attribute" do
      @rsh.should respond_to(:followed)
    end

    it "should have the right followed user" do
      @rsh.followed.should == @followed
    end
  end

  describe "validations" do
    it "should require a follower_id" do
      @rsh.follower_id = nil
      @rsh.should_not be_valid
    end

    it "should require a followed_id" do
      @rsh.followed_id = nil
      @rsh.should_not be_valid
    end
  end
end
