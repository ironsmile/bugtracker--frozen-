class Ticket < ActiveRecord::Base
  belongs_to :project
  
  Statuses = {
    :open => "Open",
    :closed => "Closed",
    :reponed => "Re-opened",
    :doc => "Documentation",
    :feedback => "Feedback",
    :disaster => "Disaster",
    :unsolvable => "Unsolvable!"
  }
  
  Priorities = {
    :minor => "Minor",
    :normal => "Normal",
    :major => "Major",
    :critical => "Critical"
  }
  
  validates_inclusion_of :status, :in => Statuses.values
  validates_inclusion_of :priority, :in => Priorities.values
  
end
