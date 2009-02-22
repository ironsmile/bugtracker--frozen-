class UsersController < ApplicationController
  
  skip_before_filter :authenticate, :only => [ :new, :create ]
  
  def index
    page = params[:page] || 1
    @users = User.paginate :page => page, :order => 'username'
  end

  def show
    @user = User.find_by_username(params[:id])
  end

  def dashboard
  end

  def new
     @user = User.new
     render :layout => "public"
  end

  def create
    if posted_param?(:user)
      @user = User.new(params[:user])
      if params[:others][:pass_confirm] != params[:user][:password]
        @user.errors.add "Password confirmation"
      else
        @user.password = hash_string(@user.password)
      end
      
      respond_to do |format|
        if @user.errors.empty? and @user.save
          flash[:notice] = "User #{@user.username} was successfully registered."
          @user.login!(session)
          format.html { redirect_to :controller => "public" }
        else
          @user.clear_password!
          format.html { render :layout => "public", :action => "new" }
        end
      end
    end
  end

  def edit
    @user = User.find_by_username(params[:id])
  end

  def update
    @user = User.find_by_username(params[:id])
    others = params[:others]
    if others[:action] == "full_name"
      @notice = "Full name changed to '#{params[:user][:full_name]}' successfully!"
    else
      if hash_string(others[:old_password]) != @user.password
        @notice_type = :error
        @notice = "Wrong old password!"
      elsif not (others[:new_password].nil? or others[:new_password].empty?)
        @user.password = hash_string( others[:new_password] )
      end
    end
    
    success = (@notice_type != :error) ? @user.update_attributes( params[:user] ) : false
    unless success
      @notice_type = :error
      @notice = @notice || @user.errors.full_messages
    else
      @notice = @notice || "Update successful!"
    end
    
    respond_to do |format|
      format.js { render :partial => "notice" }
      format.html do
        flash[@notice_type] = @notice
        redirect_to :action => :edit
      end
    end
    
  end

  def destroy
    if request.delete?
      @user = User.find_by_username(params[:id])
      @user.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
