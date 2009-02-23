class Project < ActiveRecord::Base

  TICKETS_ON_SHOW = 5

  Phases = {
    :offer => "Offer",
    :development => "Development",
    :maintenance => "Maintenance",
    :finished => "Finished"
  }

	has_and_belongs_to_many :versions
# 	has_many :document_files
	
  has_many :tickets
  
	# validations
	validates_presence_of :name
  validates_inclusion_of :phase, :in => Phases.values
end
