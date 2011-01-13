module Twitter
  module AuthenticationHelpers

    def self.included(controller)
      controller.class_eval do
        helper_method :signed_in?, :current_user
        hide_action :signed_in?, :current_user
      end
    end

    def signed_in?
      !current_user.nil?
    end

    def current_user
      @_current_user ||= user_from_session
    end

  protected

    def authenticate
      deny_access unless signed_in?
    end

    def deny_access
      store_location
      render :template => "/sessions/new", :status => :unauthorized
    end

    def user_from_session
      if session[:twitter_id].present?
        User.find_by_twitter_id(session[:twitter_id])
      end
    end

    def sign_in(user)
      session[:twitter_id] = user.twitter_id if user
    end

    def redirect_back_or(default)
      session[:return_to] ||= params[:return_to]
      if session[:return_to]
        redirect_to(session[:return_to])
      else
        redirect_to(default)
      end
      session[:return_to] = nil
    end

    def store_location(url=nil)
      session[:return_to] = nil
      session[:return_to] ||= url unless url.blank?
      session[:return_to] ||= request.request_uri if request.get?
    end
  end
end
