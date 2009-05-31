class FeedController < ApplicationController
  skip_before_filter [ :check_for_permenent_login, :authenticate ]
  
  layout nil
  
  def index
  end

  def ticket
    @ticket = Ticket.find(params[:id])
  end

  def project
  end

end
