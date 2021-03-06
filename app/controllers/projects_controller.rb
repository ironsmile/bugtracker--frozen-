class ProjectsController < ApplicationController
  
  before_filter :get_url_project, :only => [ :destroy, :update, :edit, :show ]
  before_filter :authenticate_project_manager, :except => [ :show, :index ]
  
  def index
    page = params[:page] || 1
    @projects = Project.paginate :page => page, :order => 'name'
  end

  def show
    @rss = { :href => url_for( :controller => 'feed', :action => 'project', :id => @project.id ) }
  end

  def create
    @project = Project.new(params[:project])
    success = @project.save
    responder success
    if success and params[:others][:version]
      @project.current_version = params[:others][:version]
    end
  end

  def new
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    responder @project.update_attributes(params[:project])
    if params[:others][:version] and not params[:others][:version].empty?
      @project.current_version = params[:others][:version]
    end
  end

  def destroy
    @project.destroy
    flash[:notice] = "#{@project.name} project destroyed!"
    respond_to do |format|
      format.html{ redirect_to :action => :index }
    end
  end

  private
  
  def get_url_project
    @project = Project.find(params[:id])
  end

  def responder(success)
     respond_to do |format|
      format.html do
        if success
          flash[:notice] = "Project #{@project.name} #{params[:action]}d!"
          redirect_to project_path(@project)
        else
          render :action => :new
        end
      end
    end
  end

  def authenticate_project_manager
    unless @logged_user.admin? or ( @project and @project.user.id == @logged_user.id )
      flash[:error] = "Do not play with our URLs!"
      redirect_to :action => "index"
      return false
    end
  end

end
