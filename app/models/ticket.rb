class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :version
  has_many :comments
  
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
  validates_presence_of :name
  validates_presence_of :version_id
  validates_presence_of :project_id
  validates_presence_of :description
end
