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
      user =  User.find_by_username_and_password(@user.username, hash_string(@user.password)) ||
              User.find_by_email_and_password(@user.username, hash_string(@user.password))
      if user
        user.login!(session)
        flash[:notice] = "Successfully logged in!"
        if params[:remember_me]
          auth_token = hash_string("#{@user.password}#{user.username}")
          user.persistent_login = auth_token
          user.save!
          cookies[:remembered_user] = { :value => auth_token, :expires => 42.months.from_now }
        end
        respond_to do |format|
          format.html { redirect_back }
        end
      else
#         @user.clear_password!
        flash[:error] = "Wrong username/password!"
        respond_to do |format|
          format.html { redirect_to :action => "login" }
        end
      end
    end
	end
  
  def logout
    # we trash the permenent login only on logout of the machine on which it is created for!
    unless cookies[:remembered_user].nil?
      cookies.delete(:remembered_user)
    end
    User.log_out!(session)
    flash[:notice] = "Logged out!"
    respond_to do |format|
      format.html { redirect_to :action => "login" }
    end
  end
  
  def forgotten
    @page_title = "Oops! I've forgotten my password. Me bad!"
    if posted_param?(:user)
      email = params[:user][:email]
      user = User.find_by_email(email)
      unless user.nil?
        request = PasswordResetRequest.new({
          :user_id => user.id, 
          :request_hash => hash_string("#{Time.now}#{user.password}#{user.id}") 
        })
        request.save
        UserMailer.deliver_forgotten_password(user, request.request_hash)
        flash[:notice] = "The email has been sent."
        redirect_to :action => "index"
      else
        flash[:error] = "There is no user with this email in our database!"
      end
    end
  end
  
  def reset_forgotten_password
    @page_title = "Now, go and change your password!"
    @request = PasswordResetRequest.find_by_request_hash( params[:id] )
    if @request.nil?
      flash[:error] = "Wrong request for password change!"
      redirect_to :action => "index"
    elsif ( posted_param?( :password ) )
      if( not params[:password][:new].empty? and params[:password][:new] == params[:password][:confirm] )
        flash[:notice] = "Password changed successfully. You can now log in using it."
        user = User.find(@request.user_id)
        user.password = hash_string( params[:password][:new] )
        user.save
        @request.destroy
        
        #garbage collecting
        Array(PasswordResetRequest.find_by_user_id( user.id )).each{ |r| r.destroy }
        
        redirect_to :action => "login"
      else
        flash[:error] = "Tried to save an empyt password or the confirmation did not match!"
      end
    end
  end
  
  private
  
    
  
end
