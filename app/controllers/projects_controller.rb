class ProjectsController < ApplicationController
  
  def index
    page = params[:page] || 1
    @projects = Project.paginate :page => page, :order => 'name'
  end

  def show
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
