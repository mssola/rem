
$: << File.dirname(__FILE__)

require 'spec_helper'
require 'request'


describe 'Rest API' do
  Reqs.init('http://localhost:3000')

  describe 'User' do
    # This user has to be on our database
    # TODO can be improved
    let(:user) { Factory(:user, :name => 'mssola',
                         :email => 'mikisabate@gmail.com') }

    # This user is on our database
    let(:bad)  { Factory(:user, :name => 'i_am_not_in_the_db') }

    it 'sends a valid JSON object when a user has been requested' do
      response = Reqs.do_get("/users/#{user.name}")
      response[:name].should eql(user.attributes[:name])
    end

    it 'does not show the user email' do
      response = Reqs.do_get("/users/#{user.name}")
      response[:email].should be_nil
    end

    it 'raises an exception when trying to access an invalid user' do
      expect { Reqs.do_get("/users/#{user.bad}") }.to raise_error(NoMethodError)
      expect { Reqs.do_get("/users/#{user.bad}.xml") }.to raise_error(NoMethodError)
    end

    it 'sends a valid XML object when a user has been requested' do
      response = Reqs.do_get("/users/#{user.name}.xml")
      Reqs.xml_compare(response, 'name', user.attributes['name'])
    end
  end
end
