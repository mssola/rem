require 'spec_helper'

describe "PasswordResets" do
  it 'emails user when requesting password reset' do
    user = Factory(:user)
    visit login_path
    click_link "password"
    fill_in 'email', :with => user.email
    click_button 'Reset Password'
    current_path.should eq(root_path)
    page.should have_content('Email sent with password reset instructions.')
    last_email.to.should include(user.email)
  end

  it 'does not email invalid user when requesting password reset' do
    visit login_path
    click_link "password"
    fill_in 'email', :with => "not_real@example.com"
    click_button 'Reset Password'
    current_path.should eq(root_path)
    page.should have_content('Email sent with password reset instructions.')
    last_email.should be_nil
  end
end
