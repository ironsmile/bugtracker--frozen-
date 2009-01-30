class UsersController < ApplicationController

  def index
  end

  def show
  end

  def new
     @user = User.new
     render :layout => "public"
  end

  def create
    @user = User.new(params[:user])
    @user.set_password @user.password
    if params[:others][:pass_confirm] != params[:user][:password]
      @user.errors.add "Password confirmation"
    end
    
    respond_to do |format|
      if @user.errors.empty? and @user.save
        flash[:notice] = 'User was successfully registered.'
        format.html { redirect_to :controller => "public", :action => "home" }
      else
        @user.password = ""
        format.html { render :layout=>"public", :action => "new" }
      end
    end
    
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
