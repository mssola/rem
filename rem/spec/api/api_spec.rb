
require 'spec_helper'
require File.dirname(__FILE__) + '/request'


describe 'Rest API' do
  Request.init('http://localhost:3000')

  describe 'User' do
    # TODO: this user has to be on our database, it can be improved
    let(:user) { Factory(:user, :name => 'mssola') }
    let(:bad)  { Factory(:user, :name => 'i_am_not_in_the_db') }

    it 'sends a valid JSON object when a user has been requested' do
      response = Request.do_get("/users/#{user.name}")
      response[:name].should eql(user.attributes[:name])
      response[:email].should eql(user.attributes[:email])
    end

    it 'raises an exception when trying to access an invalid user' do
      expect { Request.do_get("/users/#{user.bad}") }.to raise_error(NoMethodError)
    end

    pending 'same as above but with XML'
  end
end
