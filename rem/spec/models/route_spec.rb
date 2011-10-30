
require 'spec_helper'

describe Route do
  describe 'route relationships' do
    let(:user) { Factory(:user) }
    let(:route) { Factory(:route) }

    it "should have a reverse_route_relationships method" do
      route.should respond_to(:reverse_route_relationships)
    end

    it "should have a followers method" do
      route.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      user.follow!(route)
      route.followers.should include(user)
    end
  end
end
