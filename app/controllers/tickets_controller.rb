class TicketsController < ApplicationController
  def index
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def edit
  end

  def update
  end

  def create
  end

  def new
  end

  def destroy
  end

end
