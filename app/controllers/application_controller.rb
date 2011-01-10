class ApplicationController < ActionController::Base
  #protect_from_forgery

  helper :all
  layout 'application'

  before_filter :app_init


protected

  # Things to initalize in app
  def app_init
    add_meta(:property => 'og:title', :context => 'Zagat Food Trucks')
    add_meta(:property => 'robots',   :context => 'index,follow')
  end

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

end
