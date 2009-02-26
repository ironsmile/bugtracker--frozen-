class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  
  validates_presence_of :body
  validates_presence_of :ticket_id
end
