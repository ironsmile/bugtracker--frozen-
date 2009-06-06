class CommentsController < ApplicationController
  def index
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    success = @comment.update_attributes(params[:comment])
    respond_to do |format|
      format.js do
        if success
#           update_ticket(@comment) # we don't want to update the project, do we?
          @notice = "Your comment has been updated!"
        else
          @notice = @comment.errors.full_messages
          @notice_type = :error
        end
        render :partial => "users/notice"
      end
    end
  end

  def create
#     sleep(2)
    @comment = Comment.new(params[:comment])
    success = @comment.save
    if success
      update_ticket(@comment)
    end
    respond_to do |format|
      format.html do
        if success
          flash[:notice] = "Comment saved!"
        else
          flash[:error] = @comment.errors.full_messages
        end
        redirect_to project_ticket_path(@comment.ticket.project, @comment.ticket)
      end
      format.js do
        if success
          # renders _create.rjs
        else
          @notice = @comment.errors.full_messages
          @notice_type = :error
          render :partial => "users/notice"
        end
      end
    end
  end

  def new
  end

  def destroy
  end

  private
  
  def update_ticket(comment)
    comment.ticket.updated_at = Time.now
    comment.ticket.save!
  end

end
