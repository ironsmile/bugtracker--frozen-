# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  include ApplicationHelper
  
  before_filter :authenticate # do not forget to skip it where needed!
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'f86145c4ca3ff8650949bdc5b1ab86fa'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  protected
  
  def authenticate
    unless user_logged?
      session[:redirect_uri] = request.request_uri
      flash[:notice] = "Log yourself in first!"
      redirect_to :controller => "public", :action => "login"
      return false
    else
      @logged_user = User.find(session[:user_id])
    end
  end
  
#   def     
  
  def redirect_back
    unless session[:redirect_uri].nil?
      redirect_to session[:redirect_uri]
      session[:redirect_uri] = nil
    else
      redirect_to :controller => "public", :action => "index"
    end
  end
  
  def posted_param?(param)
    request.post? and params[param]
  end
  
end
