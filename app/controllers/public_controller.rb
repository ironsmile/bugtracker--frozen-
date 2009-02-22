class PublicController < ApplicationController

  skip_before_filter :authenticate, :except => :logout

	def index
    if user_logged?
      redirect_to :controller => "users", :action => "dashboard"
    end
	end

	def login
    if posted_param?(:user)
      @user = User.new(params[:user])
      user = User.find_by_username_and_password(@user.username, hash_string(@user.password))
      if user
        user.login!(session)
        flash[:notice] = "Successfully logged in!"
        respond_to do |format|
          format.html { redirect_back }
        end
      else
        @user.clear_password!
        flash[:error] = "Wrong username/password!"
        respond_to do |format|
          format.html { redirect_to :action => "login" }
        end
      end
    end
	end
  
  def logout
    User.log_out!(session)
    flash[:notice] = "Logged out!"
    respond_to do |format|
      format.html { redirect_to :action => "login" }
    end
  end
  
  private
  
    
  
end
