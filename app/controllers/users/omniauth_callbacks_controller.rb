class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback_from :twitter
  end

  private
  def callback_from(provider)
    provider = provider.to_s

    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.present?
      session[:oauth_token] = request.env['omniauth.auth']['credentials']['token']
      session[:oauth_token_secret] = request.env['omniauth.auth']['credentials']['secret']
      sign_in_and_redirect @user, event: :authentication
      binding.pry
    else
      redirect_to new_user_session_path
    end
  end
end
