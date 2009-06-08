class FeedController < ApplicationController
  skip_before_filter [ :check_for_permenent_login, :authenticate ]
  before_filter :http_basic_authenticate
  
  layout nil
  
  def index
  end

  def ticket
    @ticket = Ticket.find(params[:id])
  end

  def project
  end


  private
  
  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by_username_and_password( username, hash_string(password) )
      not user.nil?
    end
  end

end
