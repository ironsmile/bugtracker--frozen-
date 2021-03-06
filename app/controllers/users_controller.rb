class UsersController < ApplicationController
  
  skip_before_filter :authenticate, :only => [ :new, :create ]
  before_filter :change_restriction, :only => [ :edit, :update, :destroy ]
  
  def index
    page = params[:page] || 1
    @users = User.paginate :page => page, :order => 'username'
  end

  def show
    @user = get_url_user
  end

  def dashboard
  end

  def new
    unless user_logged?
      @user = User.new
      render :layout => "public"
    else
      flash[:notice] = "You are already logged with registered user!"
      redirect_to :action => :dashboard
    end
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
    @user = get_url_user
  end

  def update
#     sleep(3);
    @user = get_url_user
    others = params[:others]
    
    if others[:action] == "full_name"
      @notice = "Full name changed to '#{params[:user][:full_name]}' successfully!"
      @user.name = params[:user][:full_name]
      
    elsif others[:action] == "password"
      
      if hash_string(others[:old_password]) != @user.password
        @user.errors.add "Old password"
      elsif ( others[:new_password].empty? and not params[:user][:email].empty? )
        if hash_string(others[:old_password]) == @user.password
          @notice = "Email changed successfully"
          @user.email = params[:user][:email]
        else
          @user.errors.add "Wrong password!"
        end
      elsif (not (others[:new_password].nil? or 
                others[:new_password].empty? or 
                others[:new_password] != others[:new_password_confirm]) )
        @user.password = hash_string( others[:new_password] )
        @user.persistent_login = nil
      else
        @user.errors.add "Password confirmation"
      end
    
    elsif others[:action] == "group"
      
      if @logged_user.admin?
        @notice = "Group changed!"
        @user.group_id = params[:user][:group_id]
      else
        @user.errors.add "Only admins can change user's group!"
      end
      
    else
      @user.errors.add "No such update method!"
    end
    
    success = (@user.errors.empty?) ? @user.save : false
    unless success
      @notice_type = :error
      @notice = @user.errors.full_messages
    else
      @notice ||= "Update successful!"
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
      @user = get_url_user
      @user.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end


private

  def change_restriction
    unless @logged_user.admin? or @logged_user.id == get_url_user.id
      flash[:error] = "Do not play with our URLs!"
      redirect_to :action => "index"
      return false
    end
  end

  def get_url_user
    User.find_by_username(params[:id])
  end

end
