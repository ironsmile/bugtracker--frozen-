class CommentsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def create
    @comment = Comment.new(params[:comment])
    success = @comment.save
    respond_to do |format|
      format.html do
        if success
          flash[:notice] = "Comment saved!"
          @comment.ticket.updated_at = Time.now
          @comment.ticket.save
          redirect_to project_ticket_path(@comment.ticket.project, @comment.ticket)
        else
          flash[:error] = @comment.errors.full_message
          redirect_to project_ticket_path(@comment.ticket.project, @comment.ticket)
        end
      end
    end
  end

  def new
  end

  def destroy
  end

end
