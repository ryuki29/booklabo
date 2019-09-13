class TweetsController < ApplicationController
  before_action :twitter_client, only: [:create]

  def create
    client = twitter_client
    client.update("Twitter APIのテスト")
    redirect_to user_path(current_user)
  end

  private
  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = session[:oauth_token]
      config.consumer_secret = session[:oauth_token_secret]
      config.access_token = Rails.application.credentials.twitter[:twitter_api_key]
      config.access_token_secret = Rails.application.credentials.twitter[:twitter_api_secret]
    end

    return client
  end
end
