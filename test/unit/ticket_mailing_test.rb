require 'test_helper'

class TicketMailingTest < ActiveSupport::TestCase
  
  def setup
    @ticket = tickets(:monkeys_ticket)
    @user = users(:petko)
  end
  
#   def test_create_and_remove
#     tm = TicketMailing.new( {:user => @user, :ticket => @ticket} )
#     tm.save!
#     assert TicketMailing.exists?( @ticket, @user )
#     TicketMailing.remove( @ticket, @user )
#     assert !TicketMailing.exists?( @ticket, @user )
#   end
  
end
