class Comment < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :user
  has_attached_file :attachment, 
                    :path => ":rails_root/public/uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :url  => "#{SITE_URL}uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :styles => { :thumb => "90x90>", :preview => "650x650>" },
                    :whiny => false
  
  before_validation :clear_attachment
  
  validates_attachment_size :attachment, :less_than => 10.megabytes
  validates_presence_of :body
  validates_presence_of :ticket_id
  
  
  def delete_attachment=(value)
    @delete_attachment = !value.to_i.zero?
  end
  
  def delete_attachment
    !!@delete_attachment
  end
  
  alias_method :delete_attachment?, :delete_attachment
  
  def attachment_image?
    !!/image\/.*/.match(self.attachment_content_type)
  end
  
  protected
  
  def clear_attachment
    self.attachment = nil if delete_attachment? and not attachment.dirty?
  end

end
