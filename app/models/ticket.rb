class Ticket < ActiveRecord::Base

  before_destroy :destroy_cascade

  belongs_to :project
  belongs_to :version
  has_many :comments
  belongs_to :status
  belongs_to :priority
  belongs_to :user
  

  
  validates_presence_of :status_id
  validates_presence_of :priority_id
  validates_presence_of :name
  validates_presence_of :version_id
  validates_presence_of :project_id
  validates_presence_of :description
  
  
  private
  
  def destroy_cascade
    comments.each{ |c| c.destroy }
  end
  
end
