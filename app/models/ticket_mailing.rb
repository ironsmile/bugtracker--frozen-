class TicketMailing < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :user
  
  validates_presence_of :ticked_id, :user_id
  
  def self.exists?( ticket, user )
    not find_by_ticket_id_and_user_id(ticket.id, user.id).nil?
  end
  
  def self.remove( ticket, user )
    transaction do
      destroy(find_by_ticket_id_and_user_id(ticket.id, user.id))
    end
  end
  
end
