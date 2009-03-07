class PublicController < ApplicationController

  skip_before_filter :authenticate, :except => :logout
  skip_after_filter :save_last_visited_page, :only => [ :login, :logout ]

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
        if params[:remember_me]
          auth_token = hash_string("#{@user.password}#{user.username}#{Time.now}")
          user.persistent_login = auth_token
          user.save!
          cookies[:remembered_user] = { :value => auth_token, :expires => 42.months.from_now }
        end
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
    unless cookies[:remembered_user].nil? # we trash the permenent login only on logout of the machine on which it is created for!
      @logged_user.persistent_login = nil
      @logged_user.save!
      cookies.delete(:remembered_user)
    end
    User.log_out!(session)
    flash[:notice] = "Logged out!"
    respond_to do |format|
      format.html { redirect_to :action => "login" }
    end
  end
  
  private
  
    
  
end
