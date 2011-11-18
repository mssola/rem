
require 'spec_helper'


describe UsersController do
  describe 'User Rest methods' do
    it 'should raise an exception when trying to hardcode invalid user' do
      expect { get :edit, name: '5022131' }.to
        raise_error(ActionController::RoutingError)
    end
  end

  describe 'User Rest API' do
    let(:user) { Factory(:user, :name => 'test_user',
                         :email => 'lalala@gmail.com') }

    it 'should be successful when requesting an existing user' do
      get :show, name: user.name
      response.should be_success
    end

    it 'raises a RoutingError exception when requesting an invalid user' do
      expect { get :show, name: 'i_am_not_in_the_db' }.to
        raise_error(ActionController::RoutingError)
    end

    it 'gets an XML object when requested' do
      get :show, name: user.name, format: 'xml'
      xml = eval_response :xml
      xml_compare(xml, 'name', user.name)
    end

    it 'does not show private info' do
      get :show, name: user.name, format: 'json'
      json = eval_response :json
      priv = %w{ updated_at password_digest password_reset_sent_at
                 password_reset_token auth_token email }
      priv.each { |col| json[col].should be_nil }
    end
  end
end
