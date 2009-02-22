class Project < ActiveRecord::Base
	has_and_belongs_to_many :versions
# 	has_many :document_files
	belongs_to :phase
	
  has_many :tickets
  
	# validations
	validates_presence_of :name
end
