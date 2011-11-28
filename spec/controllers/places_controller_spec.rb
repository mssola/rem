
require 'spec_helper'


describe PlacesController do
  describe 'Place Rest API' do
    let(:user) { Factory(:user, :name => 'test_user',
                         :email => 'lalala@gmail.com', :auth_token => 'asd') }
    let(:route) { Factory(:route, user_id: user.id) }
    let(:place) { Factory(:place, route_id: route.id) }

    it 'should be successful when requesting an existing place' do
      get :show, name: place.name
      response.should be_success
    end

    it 'raises a RoutingError exception when requesting an invalid place' do
      expect { get :show, name: 'i_am_not_in_the_db' }.to
        raise_error(ActionController::RoutingError)
    end

    it 'does not allow a user to upload photos if not authenticated' do
      res = upload_fixture("photos/#{route.id}", 'k.jpg')
      res.class.should be_eql(Net::HTTPUnauthorized)
    end
  end
end
