
describe UserPresenter do
  it "says when none given" do
    presenter = UserPresenter.new(User.new, view)
    presenter.twitter.should include("None given")
  end
end 
