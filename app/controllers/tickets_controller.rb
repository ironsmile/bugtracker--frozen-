class TicketsController < ApplicationController

  before_filter :get_instance_project
  before_filter :init_instance_ticket, :only => [ :feed, :show, :edit, :update, :destroy ]

  def index
    page = params[:page] || 1
    @tickets = Ticket.paginate :page => page, :order => 'updated_at DESC, created_at DESC', :conditions => "project_id = #{@project.id}", :per_page => 20
  end

  def show
    @rss = { :href => full_url(link_to_static "feed/ticket/#{@ticket.id}") }
#     @ticket = get_url_ticket
    page = params[:page] || 1
    @comments = Comment.paginate :page => page, :order => "created_at DESC", :conditions => "ticket_id = #{@ticket.id}", :per_page => 10
    @comments.reverse! # much different than :order => "created_at" at pagination!
  end

  def edit
#     @ticket = get_url_ticket
  end

  def update
#     @ticket = get_url_ticket
    responder @ticket.update_attributes(params[:ticket])
  end

  def new
    @ticket = @project.tickets.new
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.user_id = @logged_user.id
    if( @ticket.version_id.nil? )
      @project.current_version = Project::DEFAULT_FIRST_VERSION
      @ticket.version_id = @project.current_version.id
    end
    responder @ticket.save
  end

  def destroy
#     @ticket = get_url_ticket
    @ticket.destroy
    flash[:notice] = "Ticket deleted!"
    redirect_to project_tickets_path(@project)
  end

  private
   
  def get_instance_project
    @project = Project.find(params[:project_id])
  end
  
  def get_url_ticket
    Ticket.find(params[:id])
  end
  
  def init_instance_ticket
    @ticket = get_url_ticket
  end
  
  def responder(success)
    respond_to do |format|
      format.html do
        if success
          flash[:notice] = "The ticket was successfully #{params[:action]}d!" # Chuck Norris successfully action'd this ticket! :)
          redirect_to project_ticket_path(@project,@ticket)
        else
          render :action => "new"
        end
      end
    end
  end
  
end
