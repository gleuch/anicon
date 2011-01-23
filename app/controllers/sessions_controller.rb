class SessionsController < ApplicationController

  before_filter :check_twitter_oauth, :only => [:create, :callback]


  def new
    @user = client.user if signed_in?
  end

  def create
    initiate_oauth_connect
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  def callback
    return_to = session[:return_to]

    request_token = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    reset_session
    session['access_token'] = access_token.token
    session['access_secret'] = access_token.secret
    store_location(return_to)

    user = client.verify_credentials

    @user = User.find_or_create_by_twitter_id(user.id)
    @user.update_attributes(
      :screen_name => user.screen_name,
      :token => access_token.token,
      :secret => access_token.secret
    )

    sign_in(@user)
    redirect_back_or(root_path)
  end


protected

  def check_twitter_oauth
    redirect_back_or(root_path) unless allow_twitter_oauth?
  end

end
