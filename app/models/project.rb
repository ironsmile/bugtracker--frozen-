class Project < ActiveRecord::Base
	has_and_belongs_to_many :versions
# 	has_many :document_files
	belongs_to :phase
	
	# validations
	validates_presence_of :name
end
