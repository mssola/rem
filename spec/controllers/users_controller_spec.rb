
require 'spec_helper'


describe UsersController do
  describe 'User Rest methods' do
    it 'should raise an exception when trying to hardcode invalid user' do
      expect { get :edit, name: '5022131' }.to
        raise_error(ActionController::RoutingError)
    end
  end
end
