class Project < ActiveRecord::Base

  before_destroy :destroy_versions

  TICKETS_ON_SHOW = 5
  DEFAULT_FIRST_VERSION = "1.0"
  
  Phases = {
    :offer => "Offer",
    :development => "Development",
    :maintenance => "Maintenance",
    :finished => "Finished"
  }

	has_many :versions
# 	has_many :document_files
	
  has_many :tickets
  
	# validations
	validates_presence_of :name
  validates_inclusion_of :phase, :in => Phases.values
  
  def current_version
    versions.sort_by{ |v| v.created_at }[-1]
  end
  
  def current_version=(val)
    versions.new( {:name => val} ).save
  end
  
  def destroy_versions
    versions.each{ |v| v.destroy }
  end
end
