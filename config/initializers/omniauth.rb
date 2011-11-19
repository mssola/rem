
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :openid, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end 
