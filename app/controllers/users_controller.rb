class UsersController < ApplicationController
  
  before_filter :authenticate, :except => [ :new, :create ]
  
#   def index
#   end

#   def show
#   end

  def new
     @user = User.new
     render :layout => "public"
  end

  def create
    @user = User.new(params[:user])
    
    if params[:user][:password].empty?
      @user.errors.add "Password"
    elsif params[:others][:pass_confirm] != params[:user][:password]
      @user.errors.add "Password confirmation"
    elsif
      @user.password = hash_string(@user.password)
    end
    
    respond_to do |format|
      if @user.errors.empty? and @user.save
        flash[:notice] = "User #{@user.username} was successfully registered."
        @user.login!(session)
        format.html { redirect_to :controller => "public", :action => "home" }
      else
        @user.clear_password!
        format.html { render :layout => "public", :action => "new" }
      end
    end
    
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
