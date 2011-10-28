
require 'spec_helper'
Dir[Rails.root.join("lib/presenters/*.rb")].each {|f| require f}

describe UserPresenter do
  it "says when none given" do
    presenter = UserPresenter.new(User.new(:name => 'mssola'), view)
    presenter.name.should include("mssola")
  end
end 
