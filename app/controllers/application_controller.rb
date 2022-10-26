
class ApplicationController < ActionController::Base
  helper_method :current_user

  def require_user 
    if session[:user_id].nil?
      flash[:error] = "Must be log in or register to access this page"
      redirect_to "/"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
