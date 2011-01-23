require 'twitter/authentication_helpers'

class ApplicationController < ActionController::Base
  include Twitter::AuthenticationHelpers

  #protect_from_forgery
  helper :all
  layout 'application'
  rescue_from Twitter::Unauthorized, :with => :force_sign_in

  before_filter :app_init


protected

  # Things to initalize in app
  def app_init
    add_meta(:property => 'og:title', :context => 'Anicon, Animated Avatar Resizing')
    add_meta(:property => 'robots',   :context => 'index,follow')
  end

  def allow_twitter_oauth?
    false # Twitter currently disabled app
  end
  helper_method :allow_twitter_oauth?

  # What environment are we in?
  def dev?; Rails.env.development?; end
  def prod?; Rails.env.production?; end
  helper_method :dev?, :prod?

  # Define which layout to use
  def embed?; (!params[:embed].blank?); end
  def which_layout; (embed? ? 'embed' : 'application'); end
  def embed_params; (embed? ? '?embed=1' : ''); end
  helper_method :embed?, :embed_params

  # App-wide helper method to assign meta tags. (Note, does not check for duplicates!)
  def add_meta(*opts)
    return if opts.blank?
    opts_hash = opts.extract_options! # Try to extract hash items
    opts_hash = {:name => (opts[0] || ''), :content => (opts[1] || '')} if opts_hash.blank? # Assume it to be regular meta tag
    (@add_meta_tags ||= []) << opts_hash
  end
  helper_method :add_meta


private

  def oauth_consumer
    @oauth_consumer ||= OAuth::Consumer.new(configatron.twitter_token, configatron.twitter_secret, :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
  end

  def client()
    Twitter.configure do |config|
      config.consumer_key       = configatron.twitter_token
      config.consumer_secret    = configatron.twitter_secret
      config.oauth_token        = current_user && !current_user.token.blank? ? current_user.token : session['access_token']
      config.oauth_token_secret = current_user && !current_user.secret.blank? ? current_user.secret : session['access_secret']
    end
    @client ||= Twitter::Client.new
  end
  helper_method :client

  def force_sign_in(exception)
    reset_session
    flash[:error] = "It seems your credentials are not good anymore. Please sign in again."
    redirect_to new_session_path
  end

  def initiate_oauth_connect
    request_token = oauth_consumer.get_request_token(:oauth_callback => callback_url)
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    redirect_to request_token.authorize_url
  end

end
