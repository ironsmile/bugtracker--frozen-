class Project < ActiveRecord::Base

  before_destroy :destroy_cascade

  TICKETS_ON_SHOW = 5
  DEFAULT_FIRST_VERSION = "1.0"
  
#   Phases = {
#     :offer => "Offer",
#     :development => "Development",
#     :maintenance => "Maintenance",
#     :finished => "Finished"
#   }

	has_many :versions
  has_many :tickets
  belongs_to :phase
  
	# validations
	validates_presence_of :name
  validates_presence_of :phase_id
#   validates_inclusion_of :phase, :in => Phases.values
  
  def current_version
    versions.sort_by{ |v| v.created_at }[-1]
  end
  
  def current_version=(val)
    versions.new( {:name => val} ).save
  end
  
  private
  
  def destroy_cascade
    tickets.each{ |t| t.destroy }
    versions.each{ |v| v.destroy }
  end
end
