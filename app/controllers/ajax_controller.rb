class AjaxController < ApplicationController

  skip_before_filter :authenticate, :only => [ :check_username, :check_email ]
  skip_after_filter :save_last_visited_page
  
  layout nil
  
  def check_username
    valid_user_field( User::USERNAME_REGEXP, User.find_by_username(params[:q]) )
  end
  
  def check_email
    valid_user_field( User::EMAIL_REGEXP, User.find_by_email(params[:q]) )
  end
  
  def textiled_preview
    render :text => textile_this( params[:q] || "" )
  end
  
  def new_comments_check
    @new_comments = get_not_displayed_comments
#     render :text => "#{@new_comments.size} new comment(s)"
  end
  
  def refresh_comments
    @comments = get_not_displayed_comments
  end
  
  private

  def valid_user_field(regexp, found_user)
    @valid = (params[:q] =~ regexp and found_user.nil?)
    respond_to do |format|
      format.js { render :partial => "validation" }
    end
  end
  
  def get_not_displayed_comments
    Ticket.find(params[:id]).comments.select{ |c| c.created_at.to_i > params[:d].to_i and c.user_id != @logged_user.id }
  end
  
end
